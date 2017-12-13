<#if ! model.attributes['javaExternalType']?? && ! model.enum??>
<#include "../S2-japigen-proforma-java-Prologue.ftl">
<@setPrologueJavaType model/>
<#include "../TypeDefProforma.ftl">
}

<#include "../S2-japigen-proforma-java-Epilogue.ftl">
</#if>