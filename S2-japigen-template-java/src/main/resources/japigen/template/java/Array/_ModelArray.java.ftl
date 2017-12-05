<#include "../S2-japigen-template-java-Prologue.ftl">
<@importFieldTypes model false/>

import org.symphonyoss.s2.common.exception.BadFormatException;

import com.symphony.s2.japigen.runtime.Model${javaCardinality};

<#include "Array.ftl">
public class ${model.camelCapitalizedName}ModelArray extends Model${javaType}
{
  public ${model.camelCapitalizedName}ModelArray(${javaType} elements)<@checkItemLimitsThrows model/>
  {
    super(elements);
    <@checkItemLimits model "Array" "this"/>
  }
}
<#include "../S2-japigen-template-java-Epilogue.ftl">