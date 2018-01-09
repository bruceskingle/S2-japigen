<#include "../S2-japigen-proforma-java-Prologue.ftl">
<@setPrologueJavaType model/>

import ${javaGenPackage}.I${modelJavaClassName}ModelHandler;

<#include "../../../template/java/Path/Path.ftl">
public interface I${modelJavaClassName}Handler extends I${modelJavaClassName}ModelHandler
{
}
<#include "../S2-japigen-proforma-java-Epilogue.ftl">