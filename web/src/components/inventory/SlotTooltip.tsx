import { Inventory, SlotWithItem } from '../../typings';
import React, { Fragment, useMemo } from 'react';
import { Items } from '../../store/items';
import { Locale } from '../../store/locale';
import ReactMarkdown from 'react-markdown';
import { useAppSelector } from '../../store';
import ClockIcon from '../utils/icons/ClockIcon';
import { getItemUrl } from '../../helpers';
import { Weight } from 'lucide-react';
import AmmoIcon from '../utils/icons/AmmoIcon';
import { FingerPrintIcon } from '../utils/icons/FingerPrintIcon';
import { DurabilityIcon } from '../utils/icons/DurabilityIcon';

const SlotTooltip: React.ForwardRefRenderFunction<
  HTMLDivElement,
  { item: SlotWithItem; inventoryType: Inventory['type']; style: React.CSSProperties }
> = ({ item, inventoryType, style }, ref) => {
  const additionalMetadata = useAppSelector((state) => state.inventory.additionalMetadata);
  const itemData = useMemo(() => Items[item.name], [item]);
  const ingredients = useMemo(() => {
    if (!item.ingredients) return null;
    return Object.entries(item.ingredients).sort((a, b) => a[1] - b[1]);
  }, [item]);
  const description = item.metadata?.description || itemData?.description;
  const ammoName = itemData?.ammoName && Items[itemData?.ammoName]?.label;

  const hasContent = useMemo(() => {
    if (inventoryType === 'crafting') return true;
    return !!(
      description ||
      ammoName ||
      item.durability !== undefined ||
      item.metadata?.ammo !== undefined ||
      item.metadata?.serial ||
      additionalMetadata.some((data: { metadata: string }) => item.metadata && item.metadata[data.metadata])
    );
  }, [description, ammoName, item, inventoryType, additionalMetadata]);

  const weightText =
    item.weight > 0
      ? item.weight >= 1000
        ? `${(item.weight / 1000).toLocaleString('en-us', { minimumFractionDigits: 2 })}kg`
        : `${item.weight.toLocaleString('en-us', { minimumFractionDigits: 0 })}g`
      : '';

  return (
    <>
      {!itemData ? (
        <div className="tooltip-wrapper" ref={ref} style={style}>
          <div className="tooltip-header">
            <span className="tooltip-title">{item.name}</span>
          </div>
        </div>
      ) : (
        <div className="tooltip-wrapper" ref={ref} style={style}>
          {/* The header: the name + the weight */}
          <div className="tooltip-header">
            <span className="tooltip-title">{item.metadata?.label || itemData.label || item.name}</span>
            {inventoryType === 'crafting' ? (
              <div className="tooltip-header-extra tooltip-crafting-duration">
                <ClockIcon />
                <span>{(item.duration !== undefined ? item.duration : 3000) / 1000}s</span>
              </div>
            ) : (
              <div className="tooltip-header-extra">
                {weightText && (
                  <>
                    <Weight size={16} strokeWidth={2} />
                    <span>{weightText}</span>
                  </>
                )}
                {item.metadata?.type && <span className="tooltip-type">{item.metadata.type}</span>}
              </div>
            )}
          </div>

          {hasContent && (
            <div className="tooltip-body">
              {description && (
                <div className="tooltip-description-block">
                  <ReactMarkdown className="tooltip-markdown">{description}</ReactMarkdown>
                </div>
              )}

              {ammoName && (
                <div className="tooltip-row tooltip-row-ammo">
                  <span className="tooltip-label">{Locale.ammo_type}</span>
                  <span className="tooltip-value">{ammoName}</span>
                </div>
              )}

              {inventoryType !== 'crafting' ? (
                <div className="tooltip-meta">
                  {item.durability !== undefined && (
                    <div className="tooltip-meta-row">
                      <DurabilityIcon />
                      <span className="tooltip-meta-label">{Math.trunc(item.durability)}</span>
                    </div>
                  )}
                  {item.metadata?.ammo !== undefined && (
                    <div className="tooltip-meta-row">
                      <AmmoIcon />
                      <span className="tooltip-meta-label">{item.metadata.ammo}</span>
                    </div>
                  )}
                  {item.metadata?.serial && (
                    <div className="tooltip-meta-row tooltip-meta-row-serial">
                      <FingerPrintIcon />
                      <span className="tooltip-meta-label">{item.metadata.serial}</span>
                    </div>
                  )}
                  {additionalMetadata.map((data: { metadata: string; value: string }, index: number) => (
                    <Fragment key={`metadata-${index}`}>
                      {item.metadata && item.metadata[data.metadata] && (
                        <div className="tooltip-plain-row">
                          <span className="tooltip-label">{data.value}:</span>
                          <span className="tooltip-value">{String(item.metadata[data.metadata])}</span>
                        </div>
                      )}
                    </Fragment>
                  ))}
                </div>
              ) : (
                <div className="tooltip-ingredients">
                  {ingredients?.map((ingredient) => {
                    const [ingName, count] = ingredient;
                    return (
                      <div className="tooltip-ingredient" key={`ingredient-${ingName}`}>
                        <img src={ingName ? getItemUrl(ingName) : 'none'} alt="" />
                        <span>
                          {count >= 1
                            ? `${count}x ${Items[ingName]?.label || ingName}`
                            : count === 0
                              ? `${Items[ingName]?.label || ingName}`
                              : `${(count as number) * 100}% ${Items[ingName]?.label || ingName}`}
                        </span>
                      </div>
                    );
                  })}
                </div>
              )}
            </div>
          )}
        </div>
      )}
    </>
  );
};

export default React.forwardRef(SlotTooltip);
