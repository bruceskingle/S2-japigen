<#include "../S2-japigen-template-java-Prologue.ftl">
<@importFieldTypes model false/>

import com.symphony.s2.japigen.collections.Model${javaCardinality};

<#include "Array.ftl">
public class ${model.camelCapitalizedName}ModelArray extends Model${javaType}
{
  public ${model.camelCapitalizedName}ModelArray(${javaType} elements)
  {
    super(elements);
  }
}
<#include "../S2-japigen-template-java-Epilogue.ftl">