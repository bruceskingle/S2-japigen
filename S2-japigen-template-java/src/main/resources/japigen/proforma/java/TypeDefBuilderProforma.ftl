<#assign subTemplateName="${.current_template_name!''}"><#include "S2-japigen-proforma-java-SubPrologue.ftl">
import com.google.protobuf.ByteString;

import org.symphonyoss.s2.common.dom.IBooleanProvider;
import org.symphonyoss.s2.common.dom.IStringProvider;
import org.symphonyoss.s2.common.dom.IIntegerProvider;
import org.symphonyoss.s2.common.dom.ILongProvider;
import org.symphonyoss.s2.common.dom.IFloatProvider;
import org.symphonyoss.s2.common.dom.IDoubleProvider;
import org.symphonyoss.s2.common.dom.IByteStringProvider;
import org.symphonyoss.s2.common.dom.json.IJsonDomNode;

import org.symphonyoss.s2.common.exception.BadFormatException;

import ${modelJavaFullyQualifiedClassName};

public class ${model.camelCapitalizedName}Builder
{
<#if model.enum??>
  public static ${modelJavaClassName} valueOf(${modelJavaFieldClassName} value) throws BadFormatException
  {
    // TODO Auto-generated method stub
    return ${modelJavaClassName}.valueOf(value);
  }
  
  public static ${modelJavaFieldClassName} to${modelJavaFieldClassName}(${modelJavaClassName} instance)
  {
    // TODO Auto-generated method stub
    return instance.toString();
  }

  <@setJavaType model/>
  public static ${modelJavaClassName} build(IJsonDomNode node) throws BadFormatException
  {
    // TODO Auto-generated method stub
    if(node instanceof I${javaElementClassName}Provider)
    {
      String value = ((I${javaElementClassName}Provider)node).as${javaElementClassName}();
      
      try
      {
        return ${modelJavaClassName}.valueOf(value);
      }
      catch(IllegalArgumentException e)
      {
        throw new BadFormatException("Value \"" + value + "\" of ${model.camelCapitalizedName} is not a valid enum constant");
      }
    }
    else
    {
      if(node == null)
        throw new BadFormatException("${model.camelCapitalizedName} is required.");
      else
        throw new BadFormatException("${model.camelCapitalizedName} must be an instance of ${javaFieldClassName} not " + node.getClass().getName());
    }
  }
<#else>
  public static ${modelJavaClassName} build(${modelJavaFieldClassName} value) throws BadFormatException
  {
    // TODO Auto-generated method stub
    return new ${modelJavaClassName}(value);
  }
  
  public static ${modelJavaFieldClassName} to${modelJavaFieldClassName}(${modelJavaClassName} instance)
  {
    // TODO Auto-generated method stub
    return instance.getValue();
  }

  <@setJavaType model/>
  public static ${modelJavaClassName} build(IJsonDomNode node) throws BadFormatException
  {
    // TODO Auto-generated method stub
    if(node instanceof I${javaElementClassName}Provider)
    {
      ${javaFieldClassName} value = ${javaConstructTypePrefix}((I${javaElementClassName}Provider)node).as${javaElementClassName}()${javaConstructTypePostfix};
      <#if requiresChecks>
        <@checkLimits "      " field "value"/>
      </#if>
      return new ${modelJavaClassName}(value);
    }
    else
    {
      throw new BadFormatException("${model.camelCapitalizedName} must be an instance of ${javaFieldClassName} not " + node.getClass().getName());
    }
  }
</#if>
<#assign subTemplateName="${.current_template_name!''}"><#include "S2-japigen-proforma-java-SubEpilogue.ftl">