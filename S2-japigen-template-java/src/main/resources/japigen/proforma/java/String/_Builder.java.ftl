<#if model.attributes['javaExternalType']?? && (model.attributes['isDirectExternal']!"false") != "true">
<#include "../S2-japigen-proforma-java-Prologue.ftl">
<@setPrologueJavaType model/>
<#include "../TypeDefBuilderProforma.ftl">
}

<#include "../S2-japigen-proforma-java-Epilogue.ftl">
</#if>