<#include "../S2-japigen-template-java-Prologue.ftl">
<@setPrologueJavaType model/>
<@importFieldTypes model false/>

import org.symphonyoss.s2.common.exception.BadFormatException;

import com.symphony.s2.japigen.runtime.Model${modelJavaCardinality};

<#include "Array.ftl">
public class ${modelJavaClassName}ModelArray extends Model${modelJavaCardinality}<${modelJavaElementClassName}>
{
  public ${modelJavaClassName}ModelArray(${modelJavaFieldClassName} elements)<@checkLimitsThrows model/>
  {
    super(elements);
    <@checkItemLimits model "Array" "this"/>
  }
}
<#include "../S2-japigen-template-java-Epilogue.ftl">