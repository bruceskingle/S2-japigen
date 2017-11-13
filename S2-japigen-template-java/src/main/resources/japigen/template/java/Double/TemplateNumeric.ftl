<#-- Generated code for all numeric types -->
<#assign subTemplateName="${.current_template_name!''}"><#include "../S2-japigen-template-java-SubPrologue.ftl">
<#include "Numeric.ftl">
public class ${model.camelCapitalizedName}ModelType
{
	private ${javaType} value_;
	
	public ${model.camelCapitalizedName}ModelType(${javaType} value)
  {
<@checkLimits model "value"/>
    value_ = value;
  }
  
  public ${javaType} getValue()
  {
    return value_;
  }
}
<#assign subTemplateName="${.current_template_name!''}"><#include "../S2-japigen-template-java-SubEpilogue.ftl">