<#include "../S2-japigen-template-java-Prologue.ftl">
<#include "../../../template/java/Object/Object.ftl">
<@importFieldTypes model/>

import ${javaGenPackage}.${model.camelCapitalizedName}ModelObject;

<@setJavaType model/>

public class ${model.camelCapitalizedName} extends ${model.camelCapitalizedName}ModelObject
{
  public ${model.camelCapitalizedName}(
<#list model.children as field><@setJavaType field/>
    ${javaType?right_pad(25)} ${field.camelName}<#sep>,
</#list>

  )
  {
    super(
<#list model.children as field>
<@setJavaType field/>
      ${field.camelName}<#sep>, 
</#list>

    );
  }
<#list model.children as field>
  <@setJavaType field/>
  <#switch field.elementType>
    <#case "OneOf">
      <@setJavaType field/>
      
  public class ${field.camelCapitalizedName} extends ${field.camelCapitalizedName}ModelObject
  {
    public ${field.camelCapitalizedName}(
      <#list field.children as ref>
        <#assign subfield=ref.reference>
        <@setJavaType ref/>
      ${javaType?right_pad(25)} ${subfield.camelName}<#sep>,
      </#list>
      
    )
    {
      super(
      <#list field.children as ref>
        <#assign subfield=ref.reference>
        ${subfield.camelName}<#sep>,
      </#list>
      );
    }
  }
      <#break>
    </#switch>
</#list>

  public static ModelObjectBuilder newBuilder()
  {
    return new Builder();
  }
  
  public static class Builder extends ModelObjectBuilder
  {
  }
}
<#include "../S2-japigen-template-java-Epilogue.ftl">