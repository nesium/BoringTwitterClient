import Lists
import RxSwift
import NSMFoundation
import UIKit

typealias PostOrCommentFuture = FutureType<Either<Boring_Types_Post, Boring_Types_Comment>>

class PostDetailViewController: TypedListViewController<PostOrCommentFuture, SelectableEntity> {
  private let entitySelectedSubject = PublishSubject<SelectableEntity>()

  let disposeBag = DisposeBag()

  var entitySelected: Observable<SelectableEntity> {
    return self.entitySelectedSubject.asObservable()
  }

  init(selectedPost: Boring_Types_Post) {
    let entitySelected = self.entitySelectedSubject
    let comments = Current.ffi.getComments(postID: selectedPost.id)
    let style = Current.theme.postDetail

    // Since our CollectionView is updated as soon as the comments are finally loaded, we'll cache
    // the measured size of our (always visible) post cell. This prevents that the cell is sized
    // incorrectly, due to an incorrect estimated height, and then relayouted again, which causes
    // a noticeable jump.
    var cachedPostCellHeight: CGFloat = 150

    let postSection = SectionData<PostOrCommentFuture>(
      uniqueSectionIdentifier: "post-detail",
      items: [.result(.left(selectedPost))],
      diffWitness: diff(),
      cellSeparator: { _, _, _ in nil },
      cellMeasure: { _, _, availableWidth in
        CGSize(width: availableWidth, height: cachedPostCellHeight)
      },
      cellUpdate: { provider, _, _ in
        provider.updateCell(PostCell.self) { cell in
          cell.applyValue(selectedPost, style: style.postCell)
          cell.authorTapped { entitySelected.onNext(.author(selectedPost.userID)) }
          cell.didUpdateLayoutAttributes = { layoutAttributes in
            cachedPostCellHeight = layoutAttributes.frame.height
          }
        }
      }
    )

    let commentsSection = comments.map { posts -> SectionData<PostOrCommentFuture> in
      SectionData(
        uniqueSectionIdentifier: "comments",
        items: posts.map { .result(.right($0)) },
        diffWitness: diff(),
        cellSeparator: SectionData.defaultCellSeparatorHandler(
          style: Current.theme.listSeparator,
          inset: .zero,
          reference: .fromAutomaticInsets
        ),
        cellMeasure: { _, _, availableWidth in CGSize(width: availableWidth, height: 150) },
        cellUpdate: { provider, future, idx in
          let comment = future.result!.right!
          provider.updateCell(CommentCell.self) { cell in
            cell.applyValue(comment, style: style.commentCell)
            cell.nameTapped = { entitySelected.onNext(.email(comment.email)) }
          }
        }
      )
    }
      .asObservable()
      // Delay this just a bit, so that the activityIndicator becomes visible.
      .delay(.milliseconds(800), scheduler: MainScheduler.instance)
      .startWith(loadingSection(uniqueSectionIdentifier: "comments"))

    let sections = commentsSection.map { [postSection, $0] }

    let selectionStrategy = ListSingleSelectionConversionStrategy<
      PostOrCommentFuture,
      SelectableEntity
    >(
      diffWitness: diff(),
      commitsOnSelection: true,
      itemToOutputTransformer: {
        switch $0 {
          case let .result(.left(post)):
            return Observable.just(SelectableEntity.post(post))
          case .result, .loading, .error:
            fatalError("Unexpected type \($0)")
        }
      },
      itemToOutputComparator: { _, _ in false },
      // Allow only selection of Boring_Types_Post values which are a `.result`.
      itemFilter: { $0.result?.left != nil }
    )

    selectionStrategy.value
      .asObservable()
      .filterNil()
      .subscribe(self.entitySelectedSubject)
      .disposed(by: self.disposeBag)

    // Provide a custom layout, which is configured for self-sizing cells.
    let layout = UICollectionViewFlowLayout()
    layout.estimatedItemSize = CGSize(width: 1, height: 150)

    super.init(
      data: TypedListViewData(sectionData: sections),
      diffWitness: diff(),
      selectionStrategy: selectionStrategy,
      placeholderView: nil,
      layout: layout
    )

    self.title = NSLocalizedString("Post Detail", comment: "")
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    // Invalidate the CollectionView layout if the preferredContentSize changes, so that our
    // cells can be remeasured with the new font sizes.
    if self.traitCollection.preferredContentSizeCategory !=
      previousTraitCollection?.preferredContentSizeCategory {
      UIView.performWithoutAnimation {
        self.invalidateLayout()
      }
    }
  }
}
