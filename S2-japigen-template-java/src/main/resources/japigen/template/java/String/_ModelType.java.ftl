<#include "../S2-japigen-template-java-Prologue.ftl">
<#include "String.ftl">
public class ${model.camelCapitalizedName}ModelType
{
  private String value_;
  
  public ${model.camelCapitalizedName}ModelType(String value)
  {
    value_ = value;
  }
  
  public String getValue()
  {
    return value_;
  }
}
<#include "../S2-japigen-template-java-Epilogue.ftl">
