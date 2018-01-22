<#include "../S2-japigen-proforma-java-Prologue.ftl">

import ${javaGenPackage}.${model.camelCapitalizedName}Model;

public class ${model.camelCapitalizedName} extends ${model.camelCapitalizedName}Model implements I${model.camelCapitalizedName}
{
  /**
   * This method will be called once by a server before any other model methods are called.
   * 
   */
  @Override
  public void start()
  {
  }
  
  /**
   * This method will be called once by a server before it is shut down.
   */
  @Override
  public void stop()
  {
  }
}
<#include "../S2-japigen-proforma-java-Epilogue.ftl">