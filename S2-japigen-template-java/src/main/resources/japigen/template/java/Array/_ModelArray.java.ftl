<#include "../S2-japigen-template-java-Prologue.ftl">
<#assign model=model.type>
<@setPrologueJavaType model/>
import javax.annotation.concurrent.Immutable;

<@importFieldTypes model true/>
import ${javaFacadePackage}.${modelJavaClassName};
import ${javaFacadePackage}.I${model.model.camelCapitalizedName};

import com.symphony.s2.japigen.runtime.IModel${modelJavaCardinality};
import com.symphony.s2.japigen.runtime.ModelArrayFactory;

import org.symphonyoss.s2.common.dom.json.IJsonDomNode;
import org.symphonyoss.s2.common.dom.json.ImmutableJsonArray;
import org.symphonyoss.s2.common.dom.json.MutableJsonArray;
import org.symphonyoss.s2.common.exception.BadFormatException;

import com.symphony.s2.japigen.runtime.Model${modelJavaCardinality};

<#include "Array.ftl">
@Immutable
public class ${modelJavaClassName}ModelArray extends Model${modelJavaCardinality}<${modelJavaElementClassName}>
{
  protected ${modelJavaClassName}ModelArray(IModel${modelJavaCardinality}<${modelJavaElementClassName}> other)<#if model.canFailValidation> throws BadFormatException</#if>
  {
    super(other);
<@checkItemLimits "    " model "Array" "this"/>
  }
  
  <#-- Constructor from Json   -->  
  protected ${modelJavaClassName}ModelArray(ImmutableJsonArray jsonArray) throws BadFormatException
  {
    super(jsonArray, jsonArray.asImmutable${modelJavaCardinality}Of(${modelJavaElementClassName}.class));
<@checkItemLimits "    " model "Array" "this"/>
  }

  public static abstract class Builder extends ModelArrayFactory.Builder implements IModel${modelJavaCardinality}<${modelJavaElementClassName}>
  {
    private ${modelJavaFieldClassName} elements__ =
    <#switch model.cardinality>
      <#case "SET">
                                          new HashSet<>();
        <#break>
        
      <#default>
                                          new LinkedList<>();
    </#switch>
    
    
    protected Builder()
    {
    }
    
    protected Builder(Builder initial)
    {
      elements__.addAll(initial.elements__);
    }
    
    @Override
    public Immutable${modelJavaFieldClassName} getElements()
    {
      return Immutable${modelJavaCardinality}.copyOf(elements__);
    }
    
    @Override
    public int size()
    {
      return elements__.size();
    }

    public ${modelJavaClassName}.Builder with(${modelJavaElementClassName} element)
    {
      elements__.add(element);
      return (${modelJavaClassName}.Builder)this;
    }

    public ${modelJavaClassName}.Builder with(${modelJavaClassName} elements)
    {
      elements__.addAll(elements.getElements());
      return (${modelJavaClassName}.Builder)this;
    }

    public ${modelJavaClassName}.Builder with(ImmutableJsonArray node) throws BadFormatException
    {
      elements__.addAll(node.asImmutableListOf(${modelJavaElementClassName}.class));
      return (${modelJavaClassName}.Builder)this;
    }
    
    @Override 
    public ImmutableJsonArray getJsonArray()
    {
      MutableJsonArray jsonArray = new MutableJsonArray();
      
      <@printModel/>
      // model.items = ${model.items}
      // model.items.baseSchema.isObjectSchema = ${model.items.baseSchema.isObjectSchema?c}
      for(${modelJavaElementClassName} value : elements__)
      <#if model.items.baseSchema.isObjectSchema>
        jsonArray.add(value.getJsonObject());
      <#else>
        jsonArray.add(value);
      </#if>
      
      return jsonArray.immutify();
    }
    
    public abstract ${modelJavaClassName} build() throws BadFormatException;
  }
}
<#include "../S2-japigen-template-java-Epilogue.ftl">