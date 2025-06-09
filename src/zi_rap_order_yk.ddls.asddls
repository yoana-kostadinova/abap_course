@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order view'

define root view entity ZI_RAP_ORDER_YK
  as select from zrap_order_yk
  composition [1..*] of ZI_RAP_ITEM_YK   as _Item
  association [0..1] to /DMO/I_Customer  as _Customer on $projection.Customer = _Customer.CustomerID
  association [0..1] to ZI_RAP_STATUS_YK as _Status   on $projection.Status = _Status.StatusId
{
  key order_uuid       as OrderUuid,
      order_id         as OrderId,
      name             as Name,
      status           as Status,
      customer         as Customer,
      creation_date    as CreationDate,
      cancelation_date as CancelationDate,
      completion_date  as CompletionDate,
      delivery_country as DeliveryCountry,
      @Semantics.amount.currencyCode: 'Currency'
      total_price      as TotalPrice,
      currency         as Currency,
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

      _Item,
      _Customer,
      _Status
}
