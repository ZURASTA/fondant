defmodule Fondant.Service.Filter.Type.Cuisine.RegionTest do
    use Fondant.Service.Case

    alias Fondant.Service.Filter.Type.Cuisine.Region

    setup do
        aa = Fondant.Service.Repo.insert!(%Fondant.Service.Locale.Model{ language: "aa" })
        zz = Fondant.Service.Repo.insert!(%Fondant.Service.Locale.Model{ language: "zz" })
        aa_bb = Fondant.Service.Repo.insert!(%Fondant.Service.Locale.Model{ language: "aa", country: "BB" })
        _zz_bb = Fondant.Service.Repo.insert!(%Fondant.Service.Locale.Model{ language: "zz", country: "BB" })

        Fondant.Service.Repo.insert!(%Region.Translation.Continent.Model{ translate_id: 1, locale_id: aa.id, term: "foo_continent_aa" })
        Fondant.Service.Repo.insert!(%Region.Translation.Continent.Model{ translate_id: 1, locale_id: zz.id, term: "foo_continent_zz" })
        Fondant.Service.Repo.insert!(%Region.Translation.Continent.Model{ translate_id: 1, locale_id: aa_bb.id, term: "foo_continent_aa_bb" })
        Fondant.Service.Repo.insert!(%Region.Translation.Continent.Model{ translate_id: 2, locale_id: aa.id, term: "foobar_continent_aa" })
        Fondant.Service.Repo.insert!(%Region.Translation.Continent.Model{ translate_id: 2, locale_id: zz.id, term: "foobar_continent_zz" })
        Fondant.Service.Repo.insert!(%Region.Translation.Continent.Model{ translate_id: 2, locale_id: aa_bb.id, term: "foobar_continent_aa_bb" })
        Fondant.Service.Repo.insert!(%Region.Translation.Continent.Model{ translate_id: 3, locale_id: aa.id, term: "bar_continent_aa" })
        Fondant.Service.Repo.insert!(%Region.Translation.Continent.Model{ translate_id: 3, locale_id: zz.id, term: "bar_continent_zz" })
        Fondant.Service.Repo.insert!(%Region.Translation.Continent.Model{ translate_id: 3, locale_id: aa_bb.id, term: "bar_continent_aa_bb" })

        Fondant.Service.Repo.insert!(%Region.Translation.Subregion.Model{ translate_id: 1 + 3, locale_id: aa.id, term: "foo_subregion_aa" })
        Fondant.Service.Repo.insert!(%Region.Translation.Subregion.Model{ translate_id: 1 + 3, locale_id: zz.id, term: "foo_subregion_zz" })
        Fondant.Service.Repo.insert!(%Region.Translation.Subregion.Model{ translate_id: 1 + 3, locale_id: aa_bb.id, term: "foo_subregion_aa_bb" })
        Fondant.Service.Repo.insert!(%Region.Translation.Subregion.Model{ translate_id: 2 + 3, locale_id: aa.id, term: "foobar_subregion_aa" })
        Fondant.Service.Repo.insert!(%Region.Translation.Subregion.Model{ translate_id: 2 + 3, locale_id: zz.id, term: "foobar_subregion_zz" })
        Fondant.Service.Repo.insert!(%Region.Translation.Subregion.Model{ translate_id: 2 + 3, locale_id: aa_bb.id, term: "foobar_subregion_aa_bb" })
        Fondant.Service.Repo.insert!(%Region.Translation.Subregion.Model{ translate_id: 3 + 3, locale_id: aa.id, term: "bar_subregion_aa" })
        Fondant.Service.Repo.insert!(%Region.Translation.Subregion.Model{ translate_id: 3 + 3, locale_id: zz.id, term: "bar_subregion_zz" })
        Fondant.Service.Repo.insert!(%Region.Translation.Subregion.Model{ translate_id: 3 + 3, locale_id: aa_bb.id, term: "bar_subregion_aa_bb" })

        Fondant.Service.Repo.insert!(%Region.Translation.Country.Model{ translate_id: 1 + 6, locale_id: aa.id, term: "foo_country_aa" })
        Fondant.Service.Repo.insert!(%Region.Translation.Country.Model{ translate_id: 1 + 6, locale_id: zz.id, term: "foo_country_zz" })
        Fondant.Service.Repo.insert!(%Region.Translation.Country.Model{ translate_id: 1 + 6, locale_id: aa_bb.id, term: "foo_country_aa_bb" })
        Fondant.Service.Repo.insert!(%Region.Translation.Country.Model{ translate_id: 2 + 6, locale_id: aa.id, term: "foobar_country_aa" })
        Fondant.Service.Repo.insert!(%Region.Translation.Country.Model{ translate_id: 2 + 6, locale_id: zz.id, term: "foobar_country_zz" })
        Fondant.Service.Repo.insert!(%Region.Translation.Country.Model{ translate_id: 2 + 6, locale_id: aa_bb.id, term: "foobar_country_aa_bb" })
        Fondant.Service.Repo.insert!(%Region.Translation.Country.Model{ translate_id: 3 + 6, locale_id: aa.id, term: "bar_country_aa" })
        Fondant.Service.Repo.insert!(%Region.Translation.Country.Model{ translate_id: 3 + 6, locale_id: zz.id, term: "bar_country_zz" })
        Fondant.Service.Repo.insert!(%Region.Translation.Country.Model{ translate_id: 3 + 6, locale_id: aa_bb.id, term: "bar_country_aa_bb" })

        Fondant.Service.Repo.insert!(%Region.Translation.Province.Model{ translate_id: 1 + 9, locale_id: aa.id, term: "foo_province_aa" })
        Fondant.Service.Repo.insert!(%Region.Translation.Province.Model{ translate_id: 1 + 9, locale_id: zz.id, term: "foo_province_zz" })
        Fondant.Service.Repo.insert!(%Region.Translation.Province.Model{ translate_id: 1 + 9, locale_id: aa_bb.id, term: "foo_province_aa_bb" })
        Fondant.Service.Repo.insert!(%Region.Translation.Province.Model{ translate_id: 2 + 9, locale_id: aa.id, term: "foobar_province_aa" })
        Fondant.Service.Repo.insert!(%Region.Translation.Province.Model{ translate_id: 2 + 9, locale_id: zz.id, term: "foobar_province_zz" })
        Fondant.Service.Repo.insert!(%Region.Translation.Province.Model{ translate_id: 2 + 9, locale_id: aa_bb.id, term: "foobar_province_aa_bb" })
        Fondant.Service.Repo.insert!(%Region.Translation.Province.Model{ translate_id: 3 + 9, locale_id: aa.id, term: "bar_province_aa" })
        Fondant.Service.Repo.insert!(%Region.Translation.Province.Model{ translate_id: 3 + 9, locale_id: zz.id, term: "bar_province_zz" })
        Fondant.Service.Repo.insert!(%Region.Translation.Province.Model{ translate_id: 3 + 9, locale_id: aa_bb.id, term: "bar_province_aa_bb" })

        foo = Fondant.Service.Repo.insert!(%Region.Model{ continent: 1, subregion: 1 + 3, country: 1 + 6, province: 1 + 9 })
        foobar = Fondant.Service.Repo.insert!(%Region.Model{ continent: 2, subregion: 2 + 3, country: 2 + 6, province: 2 + 9 })
        bar = Fondant.Service.Repo.insert!(%Region.Model{ continent: 3, subregion: 3 + 3, country: 3 + 6, province: 3 + 9 })

        {
            :ok,
            %{
                id: %{ foo: foo.id, foobar: foobar.id, bar: bar.id },
                data: %{
                    foo: %{
                        aa: %Fondant.Filter.Cuisine.Region{ id: foo.id, continent: "foo_continent_aa", subregion: "foo_subregion_aa", country: "foo_country_aa", province: "foo_province_aa" },
                        zz: %Fondant.Filter.Cuisine.Region{ id: foo.id, continent: "foo_continent_zz", subregion: "foo_subregion_zz", country: "foo_country_zz", province: "foo_province_zz" },
                        aa_bb: %Fondant.Filter.Cuisine.Region{ id: foo.id, continent: "foo_continent_aa_bb", subregion: "foo_subregion_aa_bb", country: "foo_country_aa_bb", province: "foo_province_aa_bb" }
                    },
                    foobar: %{
                        aa: %Fondant.Filter.Cuisine.Region{ id: foobar.id, continent: "foobar_continent_aa", subregion: "foobar_subregion_aa", country: "foobar_country_aa", province: "foobar_province_aa" },
                        zz: %Fondant.Filter.Cuisine.Region{ id: foobar.id, continent: "foobar_continent_zz", subregion: "foobar_subregion_zz", country: "foobar_country_zz", province: "foobar_province_zz" },
                        aa_bb: %Fondant.Filter.Cuisine.Region{ id: foobar.id, continent: "foobar_continent_aa_bb", subregion: "foobar_subregion_aa_bb", country: "foobar_country_aa_bb", province: "foobar_province_aa_bb" }
                    },
                    bar: %{
                        aa: %Fondant.Filter.Cuisine.Region{ id: bar.id, continent: "bar_continent_aa", subregion: "bar_subregion_aa", country: "bar_country_aa", province: "bar_province_aa" },
                        zz: %Fondant.Filter.Cuisine.Region{ id: bar.id, continent: "bar_continent_zz", subregion: "bar_subregion_zz", country: "bar_country_zz", province: "bar_province_zz" },
                        aa_bb: %Fondant.Filter.Cuisine.Region{ id: bar.id, continent: "bar_continent_aa_bb", subregion: "bar_subregion_aa_bb", country: "bar_country_aa_bb", province: "bar_province_aa_bb" }
                    }
                }
            }
        }
    end

    test "retrieve queryables" do
        assert Enum.sort([:any, :continent, :subregion, :country, :province]) == Enum.sort(Region.queryables())
    end

    describe "get" do
        test "non-existent region" do
            assert { :error, "Region does not exist" } == Region.get(0, "aa")
            assert { :error, "Region does not exist" } == Region.get(0, "zz")
            assert { :error, "Region does not exist" } == Region.get(0, "aa_BB")
        end

        test "non-existent locale" do
            assert { :error, "Invalid locale" } == Region.get(0, "bb")
        end

        test "non-existent translation" do
            assert { :error, "Region does not exist" } == Region.get(0, "zz_BB")
        end

        test "existing region", %{ id: %{ foo: foo_id, foobar: foobar_id, bar: bar_id }, data: region } do
            assert { :ok, region.foo.aa } == Region.get(foo_id, "aa")
            assert { :ok, region.foo.zz } == Region.get(foo_id, "zz")
            assert { :ok, region.foo.aa_bb } == Region.get(foo_id, "aa_BB")

            assert { :ok, region.foobar.aa } == Region.get(foobar_id, "aa")
            assert { :ok, region.foobar.zz } == Region.get(foobar_id, "zz")
            assert { :ok, region.foobar.aa_bb } == Region.get(foobar_id, "aa_BB")

            assert { :ok, region.bar.aa } == Region.get(bar_id, "aa")
            assert { :ok, region.bar.zz } == Region.get(bar_id, "zz")
            assert { :ok, region.bar.aa_bb } == Region.get(bar_id, "aa_BB")
        end
    end

    describe "find" do
        test "non-existent locale" do
            assert { :error, "No locale provided" } == Region.find([], [])
            assert { :error, "Invalid locale" } == Region.find([], [locale: "bb"])
        end

        test "no queries", %{ id: %{ bar: bar_id }, data: region } do
            assert { :ok, { results, page } } = Region.find([], [locale: "aa", limit: 10])
            assert bar_id == page
            assert Enum.sort([
                region.foo.aa,
                region.foobar.aa,
                region.bar.aa
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Region.find([], [locale: "zz", limit: 10])
            assert bar_id == page
            assert Enum.sort([
                region.foo.zz,
                region.foobar.zz,
                region.bar.zz
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Region.find([], [locale: "aa_BB", limit: 10])
            assert bar_id == page
            assert Enum.sort([
                region.foo.aa,
                region.foo.aa_bb,
                region.foobar.aa,
                region.foobar.aa_bb,
                region.bar.aa,
                region.bar.aa_bb
            ]) == Enum.sort(results)
        end

        test "pagination", %{ id: %{ foo: foo_id, foobar: foobar_id, bar: bar_id }, data: region } do
            assert { :ok, { results, page } } = Region.find([], [locale: "aa", limit: 1])
            assert foo_id == page
            assert [
                region.foo.aa
            ] == results

            assert { :ok, { results, page } } = Region.find([], [locale: "aa", limit: 1, page: page])
            assert foobar_id == page
            assert [
                region.foobar.aa
            ] == results

            assert { :ok, { results, page } } = Region.find([], [locale: "aa", limit: 1, page: page])
            assert bar_id == page
            assert [
                region.bar.aa
            ] == results

            assert { :ok, { results, page } } = Region.find([], [locale: "aa", limit: 1, page: page])
            assert bar_id == page
            assert [] == results
        end

        test "query continent", %{ id: %{ foo: foo_id, foobar: foobar_id }, data: region } do
            assert { :ok, { results, page } } = Region.find([continent: "f"], [locale: "aa", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                region.foo.aa,
                region.foobar.aa
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Region.find([continent: "f"], [locale: "zz", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                region.foo.zz,
                region.foobar.zz
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Region.find([continent: "f"], [locale: "aa_BB", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                region.foo.aa,
                region.foo.aa_bb,
                region.foobar.aa,
                region.foobar.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Region.find([continent: "foo_continent_a"], [locale: "aa", limit: 10])
            assert foo_id == page
            assert [
                region.foo.aa
            ] == results

            assert { :ok, { results, page } } = Region.find([continent: "foo_continent_a"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([continent: "foo_continent_a"], [locale: "aa_BB", limit: 10])
            assert foo_id == page
            assert Enum.sort([
                region.foo.aa,
                region.foo.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Region.find([continent: "barfoo"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([continent: "barfoo"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([continent: "barfoo"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([continent: "foo_country_a"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([continent: "foo_country_a"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([continent: "foo_country_a"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([continent: "f", continent: "b"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([continent: "f", continent: "b"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([continent: "f", continent: "b"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results
        end

        test "query subregion", %{ id: %{ foo: foo_id, foobar: foobar_id }, data: region } do
            assert { :ok, { results, page } } = Region.find([subregion: "f"], [locale: "aa", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                region.foo.aa,
                region.foobar.aa
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Region.find([subregion: "f"], [locale: "zz", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                region.foo.zz,
                region.foobar.zz
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Region.find([subregion: "f"], [locale: "aa_BB", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                region.foo.aa,
                region.foo.aa_bb,
                region.foobar.aa,
                region.foobar.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Region.find([subregion: "foo_subregion_a"], [locale: "aa", limit: 10])
            assert foo_id == page
            assert [
                region.foo.aa
            ] == results

            assert { :ok, { results, page } } = Region.find([subregion: "foo_subregion_a"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([subregion: "foo_subregion_a"], [locale: "aa_BB", limit: 10])
            assert foo_id == page
            assert Enum.sort([
                region.foo.aa,
                region.foo.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Region.find([subregion: "barfoo"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([subregion: "barfoo"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([subregion: "barfoo"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([subregion: "foo_country_a"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([subregion: "foo_country_a"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([subregion: "foo_country_a"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([subregion: "f", subregion: "b"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([subregion: "f", subregion: "b"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([subregion: "f", subregion: "b"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results
        end

        test "query country", %{ id: %{ foo: foo_id, foobar: foobar_id }, data: region } do
            assert { :ok, { results, page } } = Region.find([country: "f"], [locale: "aa", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                region.foo.aa,
                region.foobar.aa
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Region.find([country: "f"], [locale: "zz", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                region.foo.zz,
                region.foobar.zz
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Region.find([country: "f"], [locale: "aa_BB", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                region.foo.aa,
                region.foo.aa_bb,
                region.foobar.aa,
                region.foobar.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Region.find([country: "foo_country_a"], [locale: "aa", limit: 10])
            assert foo_id == page
            assert [
                region.foo.aa
            ] == results

            assert { :ok, { results, page } } = Region.find([country: "foo_country_a"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([country: "foo_country_a"], [locale: "aa_BB", limit: 10])
            assert foo_id == page
            assert Enum.sort([
                region.foo.aa,
                region.foo.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Region.find([country: "barfoo"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([country: "barfoo"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([country: "barfoo"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([country: "foo_continent_a"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([country: "foo_continent_a"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([country: "foo_continent_a"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([country: "f", country: "b"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([country: "f", country: "b"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([country: "f", country: "b"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results
        end

        test "query province", %{ id: %{ foo: foo_id, foobar: foobar_id }, data: region } do
            assert { :ok, { results, page } } = Region.find([province: "f"], [locale: "aa", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                region.foo.aa,
                region.foobar.aa
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Region.find([province: "f"], [locale: "zz", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                region.foo.zz,
                region.foobar.zz
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Region.find([province: "f"], [locale: "aa_BB", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                region.foo.aa,
                region.foo.aa_bb,
                region.foobar.aa,
                region.foobar.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Region.find([province: "foo_province_a"], [locale: "aa", limit: 10])
            assert foo_id == page
            assert [
                region.foo.aa
            ] == results

            assert { :ok, { results, page } } = Region.find([province: "foo_province_a"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([province: "foo_province_a"], [locale: "aa_BB", limit: 10])
            assert foo_id == page
            assert Enum.sort([
                region.foo.aa,
                region.foo.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Region.find([province: "barfoo"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([province: "barfoo"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([province: "barfoo"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([province: "foo_continent_a"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([province: "foo_continent_a"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([province: "foo_continent_a"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([province: "f", province: "b"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([province: "f", province: "b"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([province: "f", province: "b"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results
        end

        test "query any", %{ id: %{ foo: foo_id, foobar: foobar_id }, data: region } do
            assert { :ok, { results, page } } = Region.find([any: "f"], [locale: "aa", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                region.foo.aa,
                region.foobar.aa
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Region.find([any: "f"], [locale: "zz", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                region.foo.zz,
                region.foobar.zz
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Region.find([any: "f"], [locale: "aa_BB", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                region.foo.aa,
                region.foo.aa_bb,
                region.foobar.aa,
                region.foobar.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Region.find([any: "foo_continent_a"], [locale: "aa", limit: 10])
            assert foo_id == page
            assert [
                region.foo.aa
            ] == results

            assert { :ok, { results, page } } = Region.find([any: "foo_continent_a"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([any: "foo_continent_a"], [locale: "aa_BB", limit: 10])
            assert foo_id == page
            assert Enum.sort([
                region.foo.aa,
                region.foo.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Region.find([any: "foo_subregion_a"], [locale: "aa", limit: 10])
            assert foo_id == page
            assert [
                region.foo.aa
            ] == results

            assert { :ok, { results, page } } = Region.find([any: "foo_subregion_a"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([any: "foo_subregion_a"], [locale: "aa_BB", limit: 10])
            assert foo_id == page
            assert Enum.sort([
                region.foo.aa,
                region.foo.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Region.find([any: "foo_country_a"], [locale: "aa", limit: 10])
            assert foo_id == page
            assert [
                region.foo.aa
            ] == results

            assert { :ok, { results, page } } = Region.find([any: "foo_country_a"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([any: "foo_country_a"], [locale: "aa_BB", limit: 10])
            assert foo_id == page
            assert Enum.sort([
                region.foo.aa,
                region.foo.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Region.find([any: "foo_province_a"], [locale: "aa", limit: 10])
            assert foo_id == page
            assert [
                region.foo.aa
            ] == results

            assert { :ok, { results, page } } = Region.find([any: "foo_province_a"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([any: "foo_province_a"], [locale: "aa_BB", limit: 10])
            assert foo_id == page
            assert Enum.sort([
                region.foo.aa,
                region.foo.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Region.find([any: "barfoo"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([any: "barfoo"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([any: "barfoo"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([any: "f", any: "b"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([any: "f", any: "b"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([any: "f", any: "b"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results
        end

        test "all queries", %{ id: %{ foobar: foobar_id }, data: region } do
            assert { :ok, { results, page } } = Region.find([continent: "f", subregion: "foo", country: "fo", province: "f", any: "foob"], [locale: "aa", limit: 10])
            assert foobar_id == page
            assert [
                region.foobar.aa
            ] == results

            assert { :ok, { results, page } } = Region.find([continent: "f", subregion: "foo", country: "fo", province: "f", any: "bar"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([continent: "f", subregion: "foo", country: "ba", province: "f", any: "foob"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Region.find([continent: "b", subregion: "foo", country: "fo", province: "f", any: "foob"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results
        end
    end
end
