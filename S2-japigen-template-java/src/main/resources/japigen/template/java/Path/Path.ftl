<#assign subTemplateName="${.current_template_name!''}"><#include "../S2-japigen-template-java-SubPrologue.ftl">
/**
<#if isFacade??>
 * Facade for ${model}
<#else>
 * ${model}
</#if>
<#if model.summary??>
 *
 * ${model.summary}
</#if>
<#if model.description??>
 *
 * ${model.description}
</#if>
 *
 * Path					${model.path}
 * Bind Path			${model.bindPath}
 */
<#assign subTemplateName="${.current_template_name!''}"><#include "../S2-japigen-template-java-SubEpilogue.ftl">