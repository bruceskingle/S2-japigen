<#include "Numeric.ftl">
public class ${model.camelCapitalizedName}ModelType
{
	private ${javaType} value_;
	
	public ${model.camelCapitalizedName}ModelType(${javaType} value)
  {
    value_ = value;
<#if model.minimum??>

    if(value != null && value < ${model.minimum?c})
      throw new IllegalArgumentException("Value " + value + " is less than the minimum allowed of ${model.minimum}");
</#if>
<#if model.maximum??>

    if(value != null && value > ${model.maximum?c})
      throw new IllegalArgumentException("Value " + value + " is more than the maximum allowed of ${model.maximum}");
</#if>
  }
  
  public ${javaType} getValue()
  {
    return value_;
  }
}
