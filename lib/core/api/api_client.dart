import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/member.dart';
import '../models/meal.dart';
import '../models/bazar_entry.dart';
import '../models/money_transaction.dart';

part 'api_client.g.dart';

/// Retrofit API client for type-safe HTTP requests
/// Generates boilerplate code for API calls
@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  // ═══════════════════════════════════════════════════════════════════════════
  // MEMBERS
  // ═══════════════════════════════════════════════════════════════════════════

  @GET('/members')
  Future<List<Member>> getMembers();

  @GET('/members/{id}')
  Future<Member> getMember(@Path('id') String id);

  @POST('/members')
  Future<Member> createMember(@Body() Member member);

  @PUT('/members/{id}')
  Future<Member> updateMember(@Path('id') String id, @Body() Member member);

  @DELETE('/members/{id}')
  Future<void> deleteMember(@Path('id') String id);

  // ═══════════════════════════════════════════════════════════════════════════
  // MEALS
  // ═══════════════════════════════════════════════════════════════════════════

  @GET('/meals')
  Future<List<Meal>> getMeals();

  @GET('/meals')
  Future<List<Meal>> getMealsByDate(
    @Query('start') String startDate,
    @Query('end') String endDate,
  );

  @POST('/meals')
  Future<Meal> createMeal(@Body() Meal meal);

  @PUT('/meals/{id}')
  Future<Meal> updateMeal(@Path('id') String id, @Body() Meal meal);

  @DELETE('/meals/{id}')
  Future<void> deleteMeal(@Path('id') String id);

  // ═══════════════════════════════════════════════════════════════════════════
  // BAZAR
  // ═══════════════════════════════════════════════════════════════════════════

  @GET('/bazar')
  Future<List<BazarEntry>> getBazarEntries();

  @POST('/bazar')
  Future<BazarEntry> createBazarEntry(@Body() BazarEntry entry);

  @PUT('/bazar/{id}')
  Future<BazarEntry> updateBazarEntry(
    @Path('id') String id,
    @Body() BazarEntry entry,
  );

  @DELETE('/bazar/{id}')
  Future<void> deleteBazarEntry(@Path('id') String id);

  // ═══════════════════════════════════════════════════════════════════════════
  // TRANSACTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  @GET('/transactions')
  Future<List<MoneyTransaction>> getTransactions();

  @POST('/transactions')
  Future<MoneyTransaction> createTransaction(@Body() MoneyTransaction tx);

  @PUT('/transactions/{id}')
  Future<MoneyTransaction> updateTransaction(
    @Path('id') String id,
    @Body() MoneyTransaction tx,
  );

  @DELETE('/transactions/{id}')
  Future<void> deleteTransaction(@Path('id') String id);
}
