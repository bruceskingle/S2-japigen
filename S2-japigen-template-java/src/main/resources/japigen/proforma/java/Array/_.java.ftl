<#include "../S2-japigen-proforma-java-Prologue.ftl">
<@setPrologueJavaType model/>
import javax.annotation.concurrent.Immutable;

import com.symphony.s2.japigen.runtime.IModelObject;
import org.symphonyoss.s2.common.dom.json.ImmutableJsonArray;
import org.symphonyoss.s2.common.exception.BadFormatException;

<@importFieldTypes model false/>

import ${javaGenPackage}.${modelJavaClassName}ModelArray;

<#include "../../../template/java/Array/Array.ftl">
@Immutable
public class ${model.camelCapitalizedName} extends ${model.camelCapitalizedName}ModelArray
{
  public ${modelJavaClassName}(ImmutableJsonArray jsonArray, ${modelJavaFieldClassName} elements)<#if model.canFailValidation> throws BadFormatException</#if>
  {
    super(jsonArray, elements);
  }
  
  public ${modelJavaClassName}(ImmutableJsonArray jsonArray) throws BadFormatException
  {
    super(jsonArray);
  }
}
<#include "../S2-japigen-proforma-java-Epilogue.ftl">