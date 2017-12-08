<#include "../S2-japigen-proforma-java-Prologue.ftl">
<@setPrologueJavaType model/>

import ${javaGenPackage}.I${model.camelCapitalizedName}ModelObject;

<#include "../../../template/java/Object/Object.ftl">
public interface I${model.camelCapitalizedName} extends I${model.camelCapitalizedName}ModelObject
{
}
<#include "../S2-japigen-proforma-java-Epilogue.ftl">