<#include "../S2-japigen-template-java-Prologue.ftl">
<@setPrologueJavaType model/>
import javax.annotation.concurrent.Immutable;

<@importFieldTypes model true/>
import ${javaFacadePackage}.${modelJavaClassName};
import ${javaFacadePackage}.I${model.model.camelCapitalizedName};

import com.symphony.s2.japigen.runtime.IModelObject;
import com.symphony.s2.japigen.runtime.ModelArrayFactory;

import org.symphonyoss.s2.common.dom.json.IJsonDomNode;
import org.symphonyoss.s2.common.dom.json.ImmutableJsonArray;
import org.symphonyoss.s2.common.dom.json.JsonArray;
import org.symphonyoss.s2.common.exception.BadFormatException;

import com.symphony.s2.japigen.runtime.Model${modelJavaCardinality};

<#include "Array.ftl">
@Immutable
public class ${modelJavaClassName}ModelArray extends Model${modelJavaCardinality}<${modelJavaElementClassName}>
{
<@printModel/>
  public ${modelJavaClassName}ModelArray(ImmutableJsonArray jsonArray, ${modelJavaFieldClassName} elements)<#if model.canFailValidation> throws BadFormatException</#if>
  {
    super(jsonArray, elements);
    <@checkItemLimits model "Array" "this"/>
  }
  
  <#-- Constructor from Json   -->  
  protected ${modelJavaClassName}ModelArray(ImmutableJsonArray jsonArray) throws BadFormatException
  {
    super(jsonArray, parse(jsonArray));
  }
  
  <@setJavaType model/>
  private static ${modelJavaFieldClassName} parse(ImmutableJsonArray jsonArray) throws BadFormatException
  {
    ${modelJavaFieldClassName} elements = jsonArray.asImmutable${javaCardinality}Of(${modelJavaElementClassName}.class);
    <@checkItemLimits model "value" "elements"/>
    
    return elements;
  }

  public static abstract class Factory extends ModelArrayFactory<${modelJavaClassName}, I${model.model.camelCapitalizedName}>
  {
    private I${model.model.camelCapitalizedName} model_;
    
    public Factory(I${model.model.camelCapitalizedName} model)
    {
      model_ = model;
    }
    
    @Override
    public I${model.model.camelCapitalizedName} getModel()
    {
      return model_;
    }
    
    public static abstract class Builder extends ModelArrayFactory.Builder
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
      
      public ${modelJavaFieldClassName} getElements()
      {
        return elements__;
      }

      public ${modelJavaClassName}.Factory.Builder with(${modelJavaElementClassName} element)
      {
        elements__.add(element);
        return (${modelJavaClassName}.Factory.Builder)this;
      }

      public ${modelJavaClassName}.Factory.Builder with(${modelJavaClassName} elements)
      {
        elements__.addAll(elements.getElements());
        return (${modelJavaClassName}.Factory.Builder)this;
      }
      
      public abstract ${modelJavaClassName} build()<@checkLimitsClassThrows model/>;
    }
  }
}
<#include "../S2-japigen-template-java-Epilogue.ftl">