@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order projection view'
@Metadata.allowExtensions: true
@Search.searchable: true

define root view entity ZC_RAP_ORDER_YK
  as projection on ZI_RAP_ORDER_YK
{
  key     OrderUuid,
          OrderId,
          Name,
          @Consumption.valueHelpDefinition:[{ entity : {name: 'ZI_RAP_STATUS_YK', element: 'StatusId' } } ]
          @ObjectModel.text.element: ['StatusText']
          @Search.defaultSearchElement: true
          Status,
          @ObjectModel.text.element: ['Status']
          _Status.StatusText,
          Customer,
          @EndUserText.label: 'Complexity'
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_YK_ORDER_COMPLEXITY'
  virtual Complexity : abap.string(256),
          CreationDate,
          CancelationDate,
          CompletionDate,
          DeliveryCountry,
          @Semantics.amount.currencyCode: 'Currency'
          TotalPrice,
          Currency,
                CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      
          /* Associations */
          _Item : redirected to composition child ZC_RAP_ITEM_YK,
          _Customer
}
