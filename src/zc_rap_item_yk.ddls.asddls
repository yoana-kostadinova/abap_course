@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item projection view'
@Metadata.allowExtensions: true
@Search.searchable: true

define view entity ZC_RAP_ITEM_YK
  as projection on ZI_RAP_ITEM_YK
{

  key ItemUuid,
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZI_RAP_ORDER_YK', element: 'OrderId'  } }]
      @ObjectModel.text.element: ['OrderUuid']
      @Search.defaultSearchElement: true
  key OrderUuid,
      Name,
      @Semantics.amount.currencyCode: 'Currency'
      TotalPrice,
      @Consumption.valueHelpDefinition:[{ entity : {name: 'I_Currency', element: 'Currency' } } ]
      Currency,
      Quantity,
            CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,

      /* Associations */
      _Order : redirected to parent ZC_RAP_ORDER_YK,
      _Currency
}
