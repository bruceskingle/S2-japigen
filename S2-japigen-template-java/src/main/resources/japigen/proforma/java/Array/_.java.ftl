<#include "../S2-japigen-proforma-java-Prologue.ftl">
<@setPrologueJavaType model/>
import org.symphonyoss.s2.common.exception.BadFormatException;

<@importFieldTypes model false/>

import ${javaGenPackage}.${modelJavaClassName}ModelArray;

<#include "../../../template/java/Array/Array.ftl">
public class ${model.camelCapitalizedName} extends ${model.camelCapitalizedName}ModelArray
{
  public ${modelJavaClassName}(${modelJavaFieldClassName} elements)<@checkLimitsThrows model/>
  {
    super(elements);
  }
}
<#include "../S2-japigen-proforma-java-Epilogue.ftl">