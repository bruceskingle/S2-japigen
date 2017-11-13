<#include "../S2-japigen-template-java-Prologue.ftl">

import ${javaGenPackage}.${model.camelCapitalizedName}ModelType;

<#switch model.format>
 <#case "int32">
  <#assign javaType="Integer">
  <#break>
  
 <#default>
  <#assign javaType="Long">
</#switch>  

<#include "../Double/ProformaNumeric.ftl">
<#include "../S2-japigen-template-java-Epilogue.ftl">