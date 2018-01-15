<#assign subTemplateName="${.current_template_name!''}"><#include "S2-japigen-proforma-java-SubPrologue.ftl">
import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.google.protobuf.ByteString;

import org.symphonyoss.s2.common.exception.BadFormatException;

import ${javaGenPackage}.${modelJavaClassName}ModelType;

<#include "../../template/java/TypeDefHeader.ftl">
@Immutable
public class ${modelJavaClassName} extends ${modelJavaClassName}ModelType
{
  public ${modelJavaClassName}(@Nonnull ${modelJavaFieldClassName} value) throws BadFormatException
  {
    super(value);
  }
  
  public static class Builder extends ${modelJavaClassName}ModelType.Builder
  {
    @Override
    public ${modelJavaClassName} build(@Nonnull ${modelJavaFieldClassName} value) throws BadFormatException
    {
      return new ${modelJavaClassName}(value);
    }
    
    @Override
    public ${modelJavaFieldClassName} to${modelJavaFieldClassName}(${modelJavaClassName} instance)
    {
      return instance.getValue();
    }
  }
<#assign subTemplateName="${.current_template_name!''}"><#include "S2-japigen-proforma-java-SubEpilogue.ftl">