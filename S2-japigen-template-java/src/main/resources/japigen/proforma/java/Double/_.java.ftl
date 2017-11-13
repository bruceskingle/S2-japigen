<#include "../S2-japigen-template-java-Prologue.ftl">

import ${javaGenPackage}.${model.camelCapitalizedName}ModelType;

<#switch model.format>
 <#case "float">
  <#assign javaType="Float">
  <#break>
  
 <#default>
  <#assign javaType="Double">
</#switch>

<#include "ProformaNumeric.ftl">
<#include "../S2-japigen-template-java-Epilogue.ftl">
