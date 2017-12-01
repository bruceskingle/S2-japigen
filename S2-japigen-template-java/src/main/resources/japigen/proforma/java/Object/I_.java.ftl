<#include "../S2-japigen-template-java-Prologue.ftl">
<#include "../../../template/java/Object/Object.ftl">

import ${javaGenPackage}.I${model.camelCapitalizedName}ModelObject;

<@setJavaType model/>

public interface I${model.camelCapitalizedName} extends I${model.camelCapitalizedName}ModelObject
{
}
<#include "../S2-japigen-template-java-Epilogue.ftl">