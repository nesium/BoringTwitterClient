import Lists
import NSMUIKit

private let authorViewStyle = AuthorViewStyle(
  initials: LabelStyle(font: .boldSystemFont(ofSize: 30)),
  size: 60.0,
  margin: UIEdgeInsets(right: 12)
)

struct Theme {
  var posts = (
    background: UIColor.white,
    cells: PostCellStyle(
      author: authorViewStyle,
      title: LabelStyle(
        font: .preferredFont(forTextStyle: .title3),
        lineBreakMode: .byTruncatingTail,
        numberOfLines: 1,
        margin: UIEdgeInsets(bottom: 12)
      ),
      body: LabelStyle(
        font: .preferredFont(forTextStyle: .body),
        lineBreakMode: .byTruncatingTail,
        numberOfLines: 3
      ),
      padding: UIEdgeInsets(vertical: 12, horizontal: 0)
    )
  )

  var postDetail = (
    background: UIColor.white,
    postCell: PostCellStyle(
      author: authorViewStyle,
      title: LabelStyle(
        font: .preferredFont(forTextStyle: .title2),
        numberOfLines: 0,
        margin: UIEdgeInsets(bottom: 12)
      ),
      body: LabelStyle(
        font: .preferredFont(forTextStyle: .body),
        numberOfLines: 0
      ),
      padding: UIEdgeInsets(vertical: 12, horizontal: 0)
    ),
    commentCell: CommentCellStyle(
      name: LabelStyle(
        font: .preferredFont(forTextStyle: .body),
        lineBreakMode: .byTruncatingMiddle,
        numberOfLines: 1,
        margin: UIEdgeInsets(bottom: 12)
      ),
      body: LabelStyle(
        font: .preferredFont(forTextStyle: .caption1),
        numberOfLines: 0
      ),
      padding: UIEdgeInsets(vertical: 12, horizontal: 0)
    )
  )

  var loadingCell = (
    height: CGFloat(200),
    activityIndicator: CircleActivityIndicatorStyle(
      size: 40,
      lineWidth: 2,
      backgroundColor: .clear,
      foregroundColor: .red
    )
  )

  var cellBackground = (
    normal: UIColor.white,
    highlighted: UIColor.red.withAlphaComponent(0.15)
  )

  var listSeparator = LineStyle(UIScreen.main.nsm_pixel, .lightGray)
}
