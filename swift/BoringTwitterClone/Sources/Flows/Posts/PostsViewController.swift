import Lists
import RxSwift
import NSMUIKit
import UIKit

typealias PostFuture = FutureType<Boring_Types_Post>

class PostsViewController: TypedListViewController<PostFuture, SelectableEntity> {
  private let entitySelectedSubject = PublishSubject<SelectableEntity>()

  let disposeBag = DisposeBag()

  var entitySelected: Observable<SelectableEntity> {
    return self.entitySelectedSubject.asObservable()
  }

  init(posts: Observable<[Boring_Types_Post]>, title: String) {
    let postSelected = self.entitySelectedSubject
    let cellStyle = Current.theme.posts.cells

    let sections = posts.map { posts -> [SectionData<PostFuture>] in
      [SectionData(
        uniqueSectionIdentifier: "posts",
        items: posts.map(PostFuture.result),
        diffWitness: diff(),
        cellSeparator: SectionData.defaultCellSeparatorHandler(
          style: Current.theme.listSeparator,
          inset: UIEdgeInsets(left: cellStyle.author.size + cellStyle.author.margin.right),
          reference: .fromAutomaticInsets
        ),
        cellMeasure: { _, _, availableWidth in CGSize(width: availableWidth, height: 150) },
        cellUpdate: { provider, future, _ in
          let post = future.result!
          provider.updateCell(PostCell.self) { cell in
            cell.applyValue(post, style: cellStyle)
            cell.authorTapped { postSelected.onNext(.author(post.userID)) }
          }
        }
      )]
    }
      .asObservable()
      // Delay this just a bit, so that the activityIndicator becomes visible.
      .delay(.milliseconds(800), scheduler: MainScheduler.instance)
      .startWith([loadingSection(uniqueSectionIdentifier: "posts")])

    // A selection strategy is a strategy, which defines the behavior when a cell is tapped.
    // This can either lead to a single-selection, a multi-selection or nothing.
    // The `ListSingleSelectionConversionStrategy` allows us to convert the selected value into
    // something more appropriate. This can be useful when you're displaying thin objects
    // retrieved from a webservice which, upon selection, need to be resolved before being written
    // into your data model.
    let selectionStrategy = ListSingleSelectionConversionStrategy<PostFuture, SelectableEntity>(
      diffWitness: diff(),
      commitsOnSelection: true,
      itemToOutputTransformer: { Observable.just(SelectableEntity.post($0.result!)) },
      itemToOutputComparator: { _, _ in
        // A valid implementation would only be required, if we'd want to display some kind of
        // selection indicator.
        false
      },
      // Allow only selection of PostFuture values which are a `.result`.
      itemFilter: { $0.result != nil }
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

    self.title = title
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
