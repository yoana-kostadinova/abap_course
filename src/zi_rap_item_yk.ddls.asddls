@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item view'

define view entity ZI_RAP_ITEM_YK
  as select from zrap_item_yk

  association        to parent ZI_RAP_ORDER_YK as _Order    on $projection.OrderUuid = _Order.OrderUuid

  association [0..1] to I_Currency             as _Currency on $projection.Currency = _Currency.Currency
{

  key item_uuid             as ItemUuid,
  key order_uuid            as OrderUuid,
      name                  as Name,
      @Semantics.amount.currencyCode: 'Currency'
      total_price           as TotalPrice,
      currency              as Currency,
      quantity              as Quantity,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      _Order,
      _Currency
}
