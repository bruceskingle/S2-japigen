<#assign subTemplateName="${.current_template_name!''}"><#include "../S2-japigen-template-java-SubPrologue.ftl">
<#switch model.format>
 <#case "byte">
  <#assign formatDesc="Base64 encoded bytes">
  <#break>
  
 <#default>
  <#assign formatDesc="Any unicode characters">
</#switch>  

/**
<#if isFacade??>
 * Facade for
</#if>
<#if model.description??>
 * ${model.description}
</#if>
 * format ${formatDesc}
 */
<#assign subTemplateName="${.current_template_name!''}"><#include "../S2-japigen-template-java-SubEpilogue.ftl">