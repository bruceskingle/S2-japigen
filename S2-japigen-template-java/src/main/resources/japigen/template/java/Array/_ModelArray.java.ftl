<#include "../S2-japigen-template-java-Prologue.ftl">
<@setPrologueJavaType model/>
import javax.annotation.concurrent.Immutable;

<@importFieldTypes model false/>

import com.symphony.s2.japigen.runtime.IModelObject;
import org.symphonyoss.s2.common.dom.json.IJsonDomNode;
import org.symphonyoss.s2.common.dom.json.JsonArray;
import org.symphonyoss.s2.common.exception.BadFormatException;

import com.symphony.s2.japigen.runtime.Model${modelJavaCardinality};

<#include "Array.ftl">
@Immutable
public class ${modelJavaClassName}ModelArray extends Model${modelJavaCardinality}<${modelJavaElementClassName}>
{
  public ${modelJavaClassName}ModelArray(${modelJavaFieldClassName} elements)<#if model.canFailValidation> throws BadFormatException</#if>
  {
    super(elements);
    <@checkItemLimits model "Array" "this"/>
  }
  
  <#-- Constructor from Json   -->  
  protected ${modelJavaClassName}ModelArray(IJsonDomNode node) throws BadFormatException
  {
    super(parse(node));
  }
  
  <@setJavaType model/>
  private static ${modelJavaFieldClassName} parse(IJsonDomNode node) throws BadFormatException
  {
    
    if(node instanceof JsonArray)
    {
      ${modelJavaFieldClassName} elements = ((JsonArray<?>)node).asImmutable${javaCardinality}Of(${modelJavaElementClassName}.class);
      <@checkItemLimits model "value" "elements"/>
      
      return elements;
    }
    else
    {
      throw new BadFormatException("value must be an array not " + node.getClass().getName());
    }
  }
}
<#include "../S2-japigen-template-java-Epilogue.ftl">