<#include "../S2-japigen-proforma-java-Prologue.ftl">
import org.symphonyoss.s2.common.exception.BadFormatException;

<@importFieldTypes model false/>

import ${javaGenPackage}.${model.camelCapitalizedName}ModelArray;

<#include "../../../template/java/Array/Array.ftl">
public class ${model.camelCapitalizedName} extends ${model.camelCapitalizedName}ModelArray
{
  public ${model.camelCapitalizedName}(${javaType} elements)<@checkItemLimitsThrows model/>
  {
    super(elements);
  }
}
<#include "../S2-japigen-proforma-java-Epilogue.ftl">