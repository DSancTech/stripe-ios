//
//  STPCardTest.m
//  Stripe
//
//  Created by Saikat Chakrabarti on 11/5/12.
//
//

@import XCTest;

#import "STPCard.h"

@interface STPCardTest : XCTestCase

@property (nonatomic) STPCard *card;

@end

@implementation STPCardTest

- (void)setUp {
    [super setUp];
    _card = [[STPCard alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (NSDictionary *)completeAttributeDictionary {
    return @{
        @"id": @"1",
        @"exp_month": @"12",
        @"exp_year": @"2013",
        @"funding": @"debit",
        @"name": @"Smerlock Smolmes",
        @"address_line1": @"221A Baker Street",
        @"address_city": @"New York",
        @"address_state": @"NY",
        @"address_zip": @"12345",
        @"address_country": @"USA",
        @"last4": @"1234",
        @"dynamic_last4": @"5678",
        @"brand": @"MasterCard",
        @"country": @"Japan",
        @"currency": @"usd",
    };
}

#pragma mark - STPAPIResponseDecodable Tests

- (void)testInitializingCardWithAttributeDictionary {
    NSMutableDictionary *apiResponse = [[self completeAttributeDictionary] mutableCopy];
    apiResponse[@"foo"] = @"bar";
    apiResponse[@"nested"] = @{@"baz": @"bang"};
    
    
    STPCard *cardWithAttributes = [STPCard decodedObjectFromAPIResponse:apiResponse];
    XCTAssertTrue([cardWithAttributes expMonth] == 12, @"expMonth is set correctly");
    XCTAssertTrue([cardWithAttributes expYear] == 2013, @"expYear is set correctly");
    XCTAssertEqual([cardWithAttributes funding], STPCardFundingTypeDebit);
    XCTAssertEqualObjects([cardWithAttributes name], @"Smerlock Smolmes", @"name is set correctly");
    XCTAssertEqualObjects([cardWithAttributes addressLine1], @"221A Baker Street", @"addressLine1 is set correctly");
    XCTAssertEqualObjects([cardWithAttributes addressCity], @"New York", @"addressCity is set correctly");
    XCTAssertEqualObjects([cardWithAttributes addressState], @"NY", @"addressState is set correctly");
    XCTAssertEqualObjects([cardWithAttributes addressZip], @"12345", @"addressZip is set correctly");
    XCTAssertEqualObjects([cardWithAttributes addressCountry], @"USA", @"addressCountry is set correctly");
    XCTAssertEqualObjects([cardWithAttributes last4], @"1234", @"last4 is set correctly");
    XCTAssertEqualObjects([cardWithAttributes dynamicLast4], @"5678", @"last4 is set correctly");
    XCTAssertEqual([cardWithAttributes brand], STPCardBrandMasterCard, @"type is set correctly");
    XCTAssertEqualObjects([cardWithAttributes country], @"Japan", @"country is set correctly");
    XCTAssertEqualObjects([cardWithAttributes currency], @"usd", @"currency is set correctly");
    
    NSDictionary *allResponseFields = cardWithAttributes.allResponseFields;
    XCTAssertEqual(allResponseFields[@"foo"], @"bar");
    XCTAssertEqual(allResponseFields[@"last4"], @"1234");
    XCTAssertEqualObjects(allResponseFields[@"nested"], @{@"baz": @"bang"});
    XCTAssertNil(allResponseFields[@"baz"]);
}

#pragma mark - Last4 Tests

- (void)testLast4ReturnsCardNumberLast4WhenNotSet {
    self.card.number = @"4242424242424242";
    XCTAssertEqualObjects(self.card.last4, @"4242", @"last4 correctly returns the last 4 digits of the card number");
}

- (void)testLast4ReturnsNullWhenNoCardNumberSet {
    XCTAssertEqualObjects(nil, self.card.last4, @"last4 returns nil when nothing is set");
}

- (void)testLast4ReturnsNullWhenCardNumberIsLessThanLength4 {
    self.card.number = @"123";
    XCTAssertEqualObjects(nil, self.card.last4, @"last4 returns nil when number length is < 3");
}

#pragma mark - Equality Tests

- (void)testCardEquals {
    STPCard *card1 = [STPCard decodedObjectFromAPIResponse:[self completeAttributeDictionary]];
    STPCard *card2 = [STPCard decodedObjectFromAPIResponse:[self completeAttributeDictionary]];

    XCTAssertEqualObjects(card1, card1, @"card should equal itself");
    XCTAssertEqualObjects(card1, card2, @"cards with equal data should be equal");
}

#pragma mark - Description Tests

- (void)testDescriptionWorks {
    STPCard *card = [STPCard decodedObjectFromAPIResponse:[self completeAttributeDictionary]];
    XCTAssert(card.description);
}

#pragma mark -

- (void)testAddress {
    NSMutableDictionary *apiResponse = [[self completeAttributeDictionary] mutableCopy];
    STPCard *card = [STPCard decodedObjectFromAPIResponse:apiResponse];
    STPAddress *address = [card address];
    XCTAssertEqualObjects(address.name, @"Smerlock Smolmes");
    XCTAssertEqualObjects(address.line1, @"221A Baker Street");
    XCTAssertEqualObjects(address.city, @"New York");
    XCTAssertEqualObjects(address.state, @"NY");
    XCTAssertEqualObjects(address.postalCode, @"12345");
    XCTAssertEqualObjects(address.country, @"USA");
    apiResponse[@"name"] = nil;
    apiResponse[@"address_line1"] = nil;
    apiResponse[@"address_city"] = nil;
    apiResponse[@"address_state"] = nil;
    apiResponse[@"address_zip"] = nil;
    apiResponse[@"address_country"] = nil;
    STPCard *noAddressCard = [STPCard decodedObjectFromAPIResponse:apiResponse];
    XCTAssertNil([noAddressCard address]);
}

@end
