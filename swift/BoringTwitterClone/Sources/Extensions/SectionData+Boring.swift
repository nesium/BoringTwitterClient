import Lists
import UIKit

func loadingSection<T: Diffable>(uniqueSectionIdentifier: String) -> SectionData<FutureType<T>> {
  return SectionData(
    uniqueSectionIdentifier: uniqueSectionIdentifier,
    items: [.loading],
    diffWitness: diff(),
    cellSeparator: { _, _, _ in nil },
    cellMeasure: { _, _, availableWidth in
      CGSize(width: availableWidth, height: Current.theme.loadingCell.height)
    },
    cellUpdate: { provider, _, _ in
      provider.updateCell(LoadingCell.self) { cell in
        cell.startAnimating()
      }
    }
  )
}
