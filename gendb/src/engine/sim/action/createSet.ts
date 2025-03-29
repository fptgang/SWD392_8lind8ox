import {SkuPool} from "../../pool/sku";
import {Set} from "../../model/Set";
import {SetPool} from "../../pool/set";
import {Slot, SlotState} from "../../model/Slot";
import {SlotPool} from "../../pool/slot";

export function createSet(date: Date) {
  const sku = SkuPool.pickSku(date, 2);
  if (!sku) return

  const set = new Set({
    blind_box_id: sku.blindBoxId,
    is_visible: true,
    set_id: SetPool.getNextId(),
    sku_id: sku.skuId,
    sku: sku,
    updated_at: date,
    created_at: date
  })

  SetPool.add(set);
  
  for (let i = 0; i < sku.specCount; i++) {

    const slot = new Slot({
      slotId: SlotPool.getNextId(),
      createdAt: date,
      state: SlotState.AVAILABLE,
      isVisible: true,
      position: i,
      updatedAt: date,
      setId: set.set_id,
      toyId: null,
      set
    })
    SlotPool.add(slot)
  }
}