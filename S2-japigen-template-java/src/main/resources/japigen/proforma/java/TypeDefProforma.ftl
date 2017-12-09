<#assign subTemplateName="${.current_template_name!''}"><#include "S2-japigen-proforma-java-SubPrologue.ftl">
import javax.annotation.concurrent.Immutable;

import com.google.protobuf.ByteString;

import org.symphonyoss.s2.common.dom.json.IJsonDomNode;

import org.symphonyoss.s2.common.exception.BadFormatException;

import ${javaGenPackage}.${modelJavaClassName}ModelType;

<#include "../../template/java/TypeDefHeader.ftl">
@Immutable
public class ${modelJavaClassName} extends ${modelJavaClassName}ModelType
{
  public ${modelJavaClassName}(${modelJavaFieldClassName} value)<#if model.canFailValidation> throws BadFormatException</#if>
  {
    super(value);
  }
  
  public ${modelJavaClassName}(IJsonDomNode node) throws BadFormatException
  {
    super(node);
  }
  
  public static class Builder extends ${modelJavaClassName}ModelType.Builder
  {
    @Override
    public ${modelJavaClassName} build(${modelJavaFieldClassName} value)<#if model.canFailValidation> throws BadFormatException</#if>
    {
      return new ${modelJavaClassName}(value);
    }
    
    @Override
    public ${modelJavaClassName} build(IJsonDomNode node) throws BadFormatException
    {
      return new ${modelJavaClassName}(node);
    }
    
    @Override
    public ${modelJavaFieldClassName} to${modelJavaFieldClassName}(${modelJavaClassName} instance)
    {
      return instance.getValue();
    }
  }
<#assign subTemplateName="${.current_template_name!''}"><#include "S2-japigen-proforma-java-SubEpilogue.ftl">