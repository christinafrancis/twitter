//
//  ViewController.m
//  massTransit
//
//  Created by Christina Francis on 11/10/13.
//  Copyright (c) 2013 Christina Francis. All rights reserved.
//

#import "octa_PDFViewController.h"
#import "PDFScrollView.h"

@interface octa_PDFViewController ()

@end

@implementation octa_PDFViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  /*
   Open the PDF document, extract the first page, and pass the page to the PDF scroll view.
   */
  NSURL *pdfURL = [[NSBundle mainBundle] URLForResource:@"octa_sysmapoct13" withExtension:@"pdf"];
  
  CGPDFDocumentRef PDFDocument = CGPDFDocumentCreateWithURL((__bridge CFURLRef)pdfURL);
    
    
    
  CGPDFPageRef PDFPage = CGPDFDocumentGetPage(PDFDocument, 1);
  [(PDFScrollView *)self.view setPDFPage:PDFPage];
  
  CGPDFDocumentRelease(PDFDocument);

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
      return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  } else {
      return YES;
  }
}

@end
