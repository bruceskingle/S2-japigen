<#include "../S2-japigen-proforma-java-Prologue.ftl">
import javax.annotation.concurrent.Immutable;

import com.symphony.s2.japigen.runtime.ModelFactory;

import ${javaGenPackage}.${model.camelCapitalizedName}ModelFactory;

public class ${model.camelCapitalizedName}Factory extends ${model.camelCapitalizedName}ModelFactory implements I${model.camelCapitalizedName}Factory
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