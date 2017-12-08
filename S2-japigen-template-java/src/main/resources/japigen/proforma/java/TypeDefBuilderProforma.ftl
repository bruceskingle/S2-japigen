<#assign subTemplateName="${.current_template_name!''}"><#include "S2-japigen-proforma-java-SubPrologue.ftl">
import ${javaFacadePackage}.${modelJavaClassName};

import com.google.protobuf.ByteString;

public class ${model.camelCapitalizedName}Builder
{
  public ${model.javaClassName} build(${model.javaFieldType} value)
  {
    return new ${model.javaClassName}(value);
  }
  
  public ${model.javaFieldType} to${model.javaFieldType}(${model.javaClassName} instance)
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