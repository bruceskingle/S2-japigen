<#include "../S2-japigen-proforma-java-Prologue.ftl">
<@setPrologueJavaType model/>
import javax.annotation.concurrent.Immutable;

import org.symphonyoss.s2.common.dom.json.IJsonDomNode;
import org.symphonyoss.s2.common.exception.BadFormatException;

<@importFieldTypes model false/>

import ${javaGenPackage}.${modelJavaClassName}ModelArray;

<#include "../../../template/java/Array/Array.ftl">
@Immutable
public class ${model.camelCapitalizedName} extends ${model.camelCapitalizedName}ModelArray
{
  public ${modelJavaClassName}(${modelJavaFieldClassName} elements)<#if model.canFailValidation> throws BadFormatException</#if>
  {
    super(elements);
  }
  
  public ${modelJavaClassName}(IJsonDomNode node) throws BadFormatException
  {
    super(node);
  }
}
<#include "../S2-japigen-proforma-java-Epilogue.ftl">