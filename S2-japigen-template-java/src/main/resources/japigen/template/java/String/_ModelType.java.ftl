<#if ! model.attributes['javaExternalType']??>
<#include "../S2-japigen-template-java-Prologue.ftl">
<@setPrologueJavaType model/>
<#include "../TypeDefTemplate.ftl">
}

<#include "../S2-japigen-template-java-Epilogue.ftl">
</#if>