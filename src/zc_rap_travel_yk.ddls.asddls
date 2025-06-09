@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Travel projection view'
@Metadata.allowExtensions: true
@Search.searchable: true

define root view entity ZC_RAP_Travel_YK
  as projection on ZI_RAP_TRAVEL_YK as Travel
{
  key TravelUuid,
      @Search.defaultSearchElement: true
      TravelId,
      @Consumption.valueHelpDefinition: [{ entity : {name: '/DMO/I_Agency', element: 'AgencyID'} }]
      @ObjectModel.text.element: [ 'AgencyName' ]
      @Search.defaultSearchElement: true
      AgencyId,
      _Agency.Name       as AgencyName,
      @Consumption.valueHelpDefinition:[{ entity : {name: '/DMO/I_Customer', element: 'LastName' } } ]
      @ObjectModel.text.element: [ 'CustomerName' ]
      @Search.defaultSearchElement: true
      CustomerId,
      _Customer.LastName as CustomerName,
      BeginDate,
      EndDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      TotalPrice,
      @Consumption.valueHelpDefinition:[{ entity : {name: 'I_Currency', element: 'Currency' } } ]
      CurrencyCode,
      Description,
      TravelStatus,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      
      /* Associations */
      _Agency,
      _Booking : redirected to composition child ZC_RAP_Booking_YK,
      _Currency,
      _Customer
}
