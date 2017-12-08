<#assign subTemplateName="${.current_template_name!''}"><#include "S2-japigen-proforma-java-SubPrologue.ftl">
import ${modelJavaFullyQualifiedClassName};

import com.google.protobuf.ByteString;

public class ${model.camelCapitalizedName}Builder
{
  public ${modelJavaClassName} build(${modelJavaFieldClassName} value)
  {
    return new ${modelJavaClassName}(value);
  }
  
  public ${modelJavaFieldClassName} to${modelJavaFieldClassName}(${modelJavaClassName} instance)
  {
    return instance.getValue();
  }
<#----

OLD GENERATION


className ${model.class.name}
canFailValidation ${model.canFailValidation?c}

public class ${model.camelCapitalizedName}Builder
{
  public ${javaType} build(${javaBaseType} value)
  {
    return new ${javaType}(value);
  }
  
  public ${javaBaseType} to${javaBaseType}(${javaType} instance)
  {
    return instance.getValue();
  }
---->
<#assign subTemplateName="${.current_template_name!''}"><#include "S2-japigen-proforma-java-SubEpilogue.ftl">