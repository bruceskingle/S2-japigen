<#assign subTemplateName="${.current_template_name!''}"><#include "S2-japigen-template-java-SubPrologue.ftl">
<#if templateDebug??>
/*----------------------------------------------------------------------------------------------------
 * Generating for TypeDef ${model}
 *------------------------------------------------------------------------------------------------- */
</#if>
<#switch model.format>
 <#case "byte">
  <#assign formatDesc="Formatted as Base64 encoded bytes">
  <#break>
</#switch>  
/**
<#if isFacade??>
 * Facade for
</#if>
<#if model.description??>
 * ${model.description}
</#if>
<#if formatDesc??>
 * ${formatDesc}
</#if>
<#if model.minimum??>
 * minimum ${model.minimum}
</#if>
<#if model.maximum??>
 * maximum ${model.maximum}
</#if>
 */
<#assign subTemplateName="${.current_template_name!''}"><#include "S2-japigen-template-java-SubEpilogue.ftl">