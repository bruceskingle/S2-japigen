<#-- Common proforma and generated code class header for all numeric types -->
<#assign subTemplateName="${.current_template_name!''}"><#include "../S2-japigen-template-java-SubPrologue.ftl">
<#if templateDebug??>
/*----------------------------------------------------------------------------------------------------
 * Generating for Numeric ${model}
 *------------------------------------------------------------------------------------------------- */
</#if>
/**
<#if isFacade??>
 * Facade for
</#if>
<#if model.description??>
 * ${model.description}
</#if>
<#if model.minimum??>
 * minimum ${model.minimum}
</#if>
<#if model.maximum??>
 * maximum ${model.maximum}
</#if>
 */
<#assign subTemplateName="${.current_template_name!''}"><#include "../S2-japigen-template-java-SubEpilogue.ftl">