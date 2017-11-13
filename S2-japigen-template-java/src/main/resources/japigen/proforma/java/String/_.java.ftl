<#include "../S2-japigen-template-java-Prologue.ftl">

import ${javaGenPackage}.${model.camelCapitalizedName}ModelType;

<#include "../../../template/java/String/String.ftl">
public class ${model.camelCapitalizedName} extends ${model.camelCapitalizedName}ModelType
{
  public ${model.camelCapitalizedName}(String value)
  {
    super(value);
  }
}

<#include "../S2-japigen-template-java-Epilogue.ftl">