<#include "../S2-japigen-template-java-Prologue.ftl">
<@importFieldTypes model false/>

import ${javaGenPackage}.${model.camelCapitalizedName}ModelArray;

<#include "../../../template/java/Array/Array.ftl">
public class ${model.camelCapitalizedName} extends ${model.camelCapitalizedName}ModelArray
{
  public ${model.camelCapitalizedName}(${javaType} elements)
  {
    super(elements);
  }
}
<#include "../S2-japigen-template-java-Epilogue.ftl">