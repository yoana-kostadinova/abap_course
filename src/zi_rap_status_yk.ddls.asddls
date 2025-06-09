@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Status view'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

@ObjectModel.resultSet.sizeCategory: #XS

define view entity ZI_RAP_STATUS_YK as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZSTATUSYK' ) as Status
{ 
    key Status.value_low as StatusId,
    @Semantics.text: true
    Status.text          as StatusText
}
