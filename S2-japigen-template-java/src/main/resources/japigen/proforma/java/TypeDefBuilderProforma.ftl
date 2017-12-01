<#assign subTemplateName="${.current_template_name!''}"><#include "S2-japigen-proforma-java-SubPrologue.ftl">
import ${javaFacadeFullyQualifiedName};

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
<#assign subTemplateName="${.current_template_name!''}"><#include "S2-japigen-proforma-java-SubEpilogue.ftl">