<#include "../S2-japigen-template-java-Prologue.ftl">
<@importFieldTypes model/>

import com.symphony.s2.japigen.collections.ModelArray${javaCardinality};

<#include "Array.ftl">
public class ${model.camelCapitalizedName}ModelArray extends ModelArray${javaType}
{
  public ${model.camelCapitalizedName}ModelArray(${javaType} elements)
  {
    super(elements);
  }
}
<#include "../S2-japigen-template-java-Epilogue.ftl">