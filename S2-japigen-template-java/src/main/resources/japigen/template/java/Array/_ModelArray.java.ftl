<#include "../S2-japigen-template-java-Prologue.ftl">
<#include "Array.ftl">
<@importFieldTypes model/>

<@setJavaType model/>
import com.symphony.s2.japigen.collections.ModelArray${javaCardinality};

public class ${model.camelCapitalizedName}ModelArray extends ModelArray${javaType}
{
  public ${model.camelCapitalizedName}ModelArray(${javaType} elements)
  {
    super(elements);
  }
}
<#include "../S2-japigen-template-java-Epilogue.ftl">