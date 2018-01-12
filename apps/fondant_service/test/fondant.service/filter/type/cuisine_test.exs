defmodule Fondant.Service.Filter.Type.CuisineTest do
    use Fondant.Service.Case

    alias Fondant.Service.Filter.Type.Cuisine
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

        Fondant.Service.Repo.insert!(%Cuisine.Translation.Name.Model{ translate_id: 1 + 12, locale_id: aa.id, term: "foo_name_aa" })
        Fondant.Service.Repo.insert!(%Cuisine.Translation.Name.Model{ translate_id: 1 + 12, locale_id: zz.id, term: "foo_name_zz" })
        Fondant.Service.Repo.insert!(%Cuisine.Translation.Name.Model{ translate_id: 1 + 12, locale_id: aa_bb.id, term: "foo_name_aa_bb" })
        Fondant.Service.Repo.insert!(%Cuisine.Translation.Name.Model{ translate_id: 2 + 12, locale_id: aa.id, term: "foobar_name_aa" })
        Fondant.Service.Repo.insert!(%Cuisine.Translation.Name.Model{ translate_id: 2 + 12, locale_id: zz.id, term: "foobar_name_zz" })
        Fondant.Service.Repo.insert!(%Cuisine.Translation.Name.Model{ translate_id: 2 + 12, locale_id: aa_bb.id, term: "foobar_name_aa_bb" })
        Fondant.Service.Repo.insert!(%Cuisine.Translation.Name.Model{ translate_id: 3 + 12, locale_id: aa.id, term: "bar_name_aa" })
        Fondant.Service.Repo.insert!(%Cuisine.Translation.Name.Model{ translate_id: 3 + 12, locale_id: zz.id, term: "bar_name_zz" })
        Fondant.Service.Repo.insert!(%Cuisine.Translation.Name.Model{ translate_id: 3 + 12, locale_id: aa_bb.id, term: "bar_name_aa_bb" })

        region_foo = Fondant.Service.Repo.insert!(%Region.Model{ ref: "foo", ref_id: Ecto.UUID.generate(), continent: 1, subregion: 1 + 3, country: 1 + 6, province: 1 + 9 })
        region_foobar = Fondant.Service.Repo.insert!(%Region.Model{ ref: "foobar", ref_id: Ecto.UUID.generate(), continent: 2, subregion: 2 + 3, country: 2 + 6, province: 2 + 9 })
        region_bar = Fondant.Service.Repo.insert!(%Region.Model{ ref: "bar", ref_id: Ecto.UUID.generate(), continent: 3, subregion: 3 + 3, country: 3 + 6, province: 3 + 9 })

        foo = Fondant.Service.Repo.insert!(%Cuisine.Model{ name: 1 + 12, region_id: region_foo.id })
        foobar = Fondant.Service.Repo.insert!(%Cuisine.Model{ name: 2 + 12, region_id: region_foobar.id })
        bar = Fondant.Service.Repo.insert!(%Cuisine.Model{ name: 3 + 12, region_id: region_bar.id })

        {
            :ok,
            %{
                id: %{ foo: foo.id, foobar: foobar.id, bar: bar.id },
                region_id: %{ foo: region_foo.id, foobar: region_foobar.id, bar: region_bar.id },
                data: %{
                    foo: %{
                        aa: %Fondant.Filter.Cuisine{ id: foo.id, name: "foo_name_aa", region: %Fondant.Filter.Cuisine.Region{ id: region_foo.id, continent: "foo_continent_aa", subregion: "foo_subregion_aa", country: "foo_country_aa", province: "foo_province_aa" } },
                        zz: %Fondant.Filter.Cuisine{ id: foo.id, name: "foo_name_zz", region: %Fondant.Filter.Cuisine.Region{ id: region_foo.id, continent: "foo_continent_zz", subregion: "foo_subregion_zz", country: "foo_country_zz", province: "foo_province_zz" } },
                        aa_bb: %Fondant.Filter.Cuisine{ id: foo.id, name: "foo_name_aa_bb", region: %Fondant.Filter.Cuisine.Region{ id: region_foo.id, continent: "foo_continent_aa_bb", subregion: "foo_subregion_aa_bb", country: "foo_country_aa_bb", province: "foo_province_aa_bb" } }
                    },
                    foobar: %{
                        aa: %Fondant.Filter.Cuisine{ id: foobar.id, name: "foobar_name_aa", region: %Fondant.Filter.Cuisine.Region{ id: region_foobar.id, continent: "foobar_continent_aa", subregion: "foobar_subregion_aa", country: "foobar_country_aa", province: "foobar_province_aa" } },
                        zz: %Fondant.Filter.Cuisine{ id: foobar.id, name: "foobar_name_zz", region: %Fondant.Filter.Cuisine.Region{ id: region_foobar.id, continent: "foobar_continent_zz", subregion: "foobar_subregion_zz", country: "foobar_country_zz", province: "foobar_province_zz" } },
                        aa_bb: %Fondant.Filter.Cuisine{ id: foobar.id, name: "foobar_name_aa_bb", region: %Fondant.Filter.Cuisine.Region{ id: region_foobar.id, continent: "foobar_continent_aa_bb", subregion: "foobar_subregion_aa_bb", country: "foobar_country_aa_bb", province: "foobar_province_aa_bb" } }
                    },
                    bar: %{
                        aa: %Fondant.Filter.Cuisine{ id: bar.id, name: "bar_name_aa", region: %Fondant.Filter.Cuisine.Region{ id: region_bar.id, continent: "bar_continent_aa", subregion: "bar_subregion_aa", country: "bar_country_aa", province: "bar_province_aa" } },
                        zz: %Fondant.Filter.Cuisine{ id: bar.id, name: "bar_name_zz", region: %Fondant.Filter.Cuisine.Region{ id: region_bar.id, continent: "bar_continent_zz", subregion: "bar_subregion_zz", country: "bar_country_zz", province: "bar_province_zz" } },
                        aa_bb: %Fondant.Filter.Cuisine{ id: bar.id, name: "bar_name_aa_bb", region: %Fondant.Filter.Cuisine.Region{ id: region_bar.id, continent: "bar_continent_aa_bb", subregion: "bar_subregion_aa_bb", country: "bar_country_aa_bb", province: "bar_province_aa_bb" } }
                    }
                }
            }
        }
    end

    test "retrieve queryables" do
        assert Enum.sort([:any, :name, :region]) == Enum.sort(Cuisine.queryables())
    end

    describe "get" do
        test "non-existent cuisine" do
            assert { :error, "Cuisine does not exist" } == Cuisine.get(0, "aa")
            assert { :error, "Cuisine does not exist" } == Cuisine.get(0, "zz")
            assert { :error, "Cuisine does not exist" } == Cuisine.get(0, "aa_BB")
        end

        test "non-existent locale" do
            assert { :error, "Invalid locale" } == Cuisine.get(0, "bb")
        end

        test "non-existent translation" do
            assert { :error, "Cuisine does not exist" } == Cuisine.get(0, "zz_BB")
        end

        test "existing cuisine", %{ id: %{ foo: foo_id, foobar: foobar_id, bar: bar_id }, data: cuisine } do
            assert { :ok, cuisine.foo.aa } == Cuisine.get(foo_id, "aa")
            assert { :ok, cuisine.foo.zz } == Cuisine.get(foo_id, "zz")
            assert { :ok, cuisine.foo.aa_bb } == Cuisine.get(foo_id, "aa_BB")

            assert { :ok, cuisine.foobar.aa } == Cuisine.get(foobar_id, "aa")
            assert { :ok, cuisine.foobar.zz } == Cuisine.get(foobar_id, "zz")
            assert { :ok, cuisine.foobar.aa_bb } == Cuisine.get(foobar_id, "aa_BB")

            assert { :ok, cuisine.bar.aa } == Cuisine.get(bar_id, "aa")
            assert { :ok, cuisine.bar.zz } == Cuisine.get(bar_id, "zz")
            assert { :ok, cuisine.bar.aa_bb } == Cuisine.get(bar_id, "aa_BB")
        end
    end

    describe "find" do
        test "non-existent locale" do
            assert { :error, "No locale provided" } == Cuisine.find([], [])
            assert { :error, "Invalid locale" } == Cuisine.find([], [locale: "bb"])
        end

        test "no queries", %{ id: %{ bar: bar_id }, data: cuisine } do
            assert { :ok, { results, page } } = Cuisine.find([], [locale: "aa", limit: 10])
            assert bar_id == page
            assert Enum.sort([
                cuisine.foo.aa,
                cuisine.foobar.aa,
                cuisine.bar.aa
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([], [locale: "zz", limit: 10])
            assert bar_id == page
            assert Enum.sort([
                cuisine.foo.zz,
                cuisine.foobar.zz,
                cuisine.bar.zz
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([], [locale: "aa_BB", limit: 10])
            assert bar_id == page
            assert Enum.sort([
                cuisine.foo.aa,
                cuisine.foo.aa_bb,
                cuisine.foobar.aa,
                cuisine.foobar.aa_bb,
                cuisine.bar.aa,
                cuisine.bar.aa_bb
            ]) == Enum.sort(results)
        end

        test "pagination", %{ id: %{ foo: foo_id, foobar: foobar_id, bar: bar_id }, data: cuisine } do
            assert { :ok, { results, page } } = Cuisine.find([], [locale: "aa", limit: 1])
            assert foo_id == page
            assert [
                cuisine.foo.aa
            ] == results

            assert { :ok, { results, page } } = Cuisine.find([], [locale: "aa", limit: 1, page: page])
            assert foobar_id == page
            assert [
                cuisine.foobar.aa
            ] == results

            assert { :ok, { results, page } } = Cuisine.find([], [locale: "aa", limit: 1, page: page])
            assert bar_id == page
            assert [
                cuisine.bar.aa
            ] == results

            assert { :ok, { results, page } } = Cuisine.find([], [locale: "aa", limit: 1, page: page])
            assert bar_id == page
            assert [] == results
        end

        test "query name", %{ id: %{ foo: foo_id, foobar: foobar_id }, data: cuisine } do
            assert { :ok, { results, page } } = Cuisine.find([name: "f"], [locale: "aa", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                cuisine.foo.aa,
                cuisine.foobar.aa
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([name: "f"], [locale: "zz", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                cuisine.foo.zz,
                cuisine.foobar.zz
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([name: "f"], [locale: "aa_BB", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                cuisine.foo.aa,
                cuisine.foo.aa_bb,
                cuisine.foobar.aa,
                cuisine.foobar.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([name: "foo_name_a"], [locale: "aa", limit: 10])
            assert foo_id == page
            assert [
                cuisine.foo.aa
            ] == results

            assert { :ok, { results, page } } = Cuisine.find([name: "foo_name_a"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([name: "foo_name_a"], [locale: "aa_BB", limit: 10])
            assert foo_id == page
            assert Enum.sort([
                cuisine.foo.aa,
                cuisine.foo.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([name: "barfoo"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([name: "barfoo"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([name: "barfoo"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([name: "foo_type_a"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([name: "foo_type_a"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([name: "foo_type_a"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([name: "f", name: "b"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([name: "f", name: "b"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([name: "f", name: "b"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results
        end

        test "query region", %{ id: %{ foo: foo_id, foobar: foobar_id }, region_id: %{ foo: region_foo_id, foobar: region_foobar_id }, data: cuisine } do
            assert { :ok, { results, page } } = Cuisine.find([region: [id: region_foo_id]], [locale: "aa", limit: 10])
            assert foo_id == page
            assert [
                cuisine.foo.aa
            ] == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([region: [id: region_foobar_id]], [locale: "zz", limit: 10])
            assert foobar_id == page
            assert [
                cuisine.foobar.zz
            ] == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([region: [id: region_foo_id]], [locale: "aa_BB", limit: 10])
            assert foo_id == page
            assert Enum.sort([
                cuisine.foo.aa,
                cuisine.foo.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([region: [continent: "f"]], [locale: "aa", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                cuisine.foo.aa,
                cuisine.foobar.aa
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([region: [continent: "f"]], [locale: "zz", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                cuisine.foo.zz,
                cuisine.foobar.zz
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([region: [continent: "f"]], [locale: "aa_BB", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                cuisine.foo.aa,
                cuisine.foo.aa_bb,
                cuisine.foobar.aa,
                cuisine.foobar.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([region: [subregion: "f"]], [locale: "aa", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                cuisine.foo.aa,
                cuisine.foobar.aa
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([region: [subregion: "f"]], [locale: "zz", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                cuisine.foo.zz,
                cuisine.foobar.zz
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([region: [subregion: "f"]], [locale: "aa_BB", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                cuisine.foo.aa,
                cuisine.foo.aa_bb,
                cuisine.foobar.aa,
                cuisine.foobar.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([region: [country: "f"]], [locale: "aa", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                cuisine.foo.aa,
                cuisine.foobar.aa
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([region: [country: "f"]], [locale: "zz", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                cuisine.foo.zz,
                cuisine.foobar.zz
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([region: [country: "f"]], [locale: "aa_BB", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                cuisine.foo.aa,
                cuisine.foo.aa_bb,
                cuisine.foobar.aa,
                cuisine.foobar.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([region: [province: "f"]], [locale: "aa", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                cuisine.foo.aa,
                cuisine.foobar.aa
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([region: [province: "f"]], [locale: "zz", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                cuisine.foo.zz,
                cuisine.foobar.zz
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([region: [province: "f"]], [locale: "aa_BB", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                cuisine.foo.aa,
                cuisine.foo.aa_bb,
                cuisine.foobar.aa,
                cuisine.foobar.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([region: [continent: "foo_continent_a"]], [locale: "aa", limit: 10])
            assert foo_id == page
            assert [
                cuisine.foo.aa
            ] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [continent: "foo_continent_a"]], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [continent: "foo_continent_a"]], [locale: "aa_BB", limit: 10])
            assert foo_id == page
            assert Enum.sort([
                cuisine.foo.aa,
                cuisine.foo.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([region: [subregion: "foo_subregion_a"]], [locale: "aa", limit: 10])
            assert foo_id == page
            assert [
                cuisine.foo.aa
            ] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [subregion: "foo_subregion_a"]], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [subregion: "foo_subregion_a"]], [locale: "aa_BB", limit: 10])
            assert foo_id == page
            assert Enum.sort([
                cuisine.foo.aa,
                cuisine.foo.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([region: [country: "foo_country_a"]], [locale: "aa", limit: 10])
            assert foo_id == page
            assert [
                cuisine.foo.aa
            ] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [country: "foo_country_a"]], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [country: "foo_country_a"]], [locale: "aa_BB", limit: 10])
            assert foo_id == page
            assert Enum.sort([
                cuisine.foo.aa,
                cuisine.foo.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([region: [province: "foo_province_a"]], [locale: "aa", limit: 10])
            assert foo_id == page
            assert [
                cuisine.foo.aa
            ] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [province: "foo_province_a"]], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [province: "foo_province_a"]], [locale: "aa_BB", limit: 10])
            assert foo_id == page
            assert Enum.sort([
                cuisine.foo.aa,
                cuisine.foo.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([region: [id: 0]], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [id: 0]], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [id: 0]], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [continent: "barfoo"]], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [continent: "barfoo"]], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [continent: "barfoo"]], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [subregion: "barfoo"]], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [subregion: "barfoo"]], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [subregion: "barfoo"]], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [country: "barfoo"]], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [country: "barfoo"]], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [country: "barfoo"]], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [province: "barfoo"]], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [province: "barfoo"]], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [province: "barfoo"]], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [id: 0], region: [id: -1]], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [id: 0], region: [id: -1]], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [id: 0], region: [id: -1]], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [continent: "f"], region: [continent: "b"]], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [continent: "f"], region: [continent: "b"]], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [continent: "f"], region: [continent: "b"]], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [subregion: "f"], region: [subregion: "b"]], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [subregion: "f"], region: [subregion: "b"]], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [subregion: "f"], region: [subregion: "b"]], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [country: "f"], region: [country: "b"]], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [country: "f"], region: [country: "b"]], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [country: "f"], region: [country: "b"]], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [province: "f"], region: [province: "b"]], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [province: "f"], region: [province: "b"]], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [province: "f"], region: [province: "b"]], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [id: region_foo_id, continent: "foo_continent_a", subregion: "foo_subregion_a", country: "foo_country_a", province: "foo_province_a"]], [locale: "aa_BB", limit: 10])
            assert foo_id == page
            assert Enum.sort([
                cuisine.foo.aa,
                cuisine.foo.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([region: [id: region_foobar_id, continent: "foo_continent_a", subregion: "foo_subregion_a", country: "foo_country_a", province: "foo_province_a"]], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([region: [id: region_foobar_id, continent: "f", subregion: "f", country: "f", province: "f"]], [locale: "aa_BB", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                cuisine.foobar.aa,
                cuisine.foobar.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([region: [id: region_foo_id, continent: "foo_continent_aa_B", subregion: "foo_subregion_a", country: "foo_country_a", province: "foo_province_a"]], [locale: "aa_BB", limit: 10])
            assert foo_id == page
            assert [
                cuisine.foo.aa_bb
            ] == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([region: [id: region_foo_id, continent: "foo_continent_a", subregion: "foo_subregion_aa_B", country: "foo_country_a", province: "foo_province_a"]], [locale: "aa_BB", limit: 10])
            assert foo_id == page
            assert [
                cuisine.foo.aa_bb
            ] == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([region: [id: region_foo_id, continent: "foo_continent_a", subregion: "foo_subregion_a", country: "foo_country_aa_B", province: "foo_province_a"]], [locale: "aa_BB", limit: 10])
            assert foo_id == page
            assert [
                cuisine.foo.aa_bb
            ] == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([region: [id: region_foo_id, continent: "foo_continent_a", subregion: "foo_subregion_a", country: "foo_country_a", province: "foo_province_aa_B"]], [locale: "aa_BB", limit: 10])
            assert foo_id == page
            assert [
                cuisine.foo.aa_bb
            ] == Enum.sort(results)
        end

        test "query any", %{ id: %{ foo: foo_id, foobar: foobar_id }, data: cuisine } do
            assert { :ok, { results, page } } = Cuisine.find([any: "f"], [locale: "aa", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                cuisine.foo.aa,
                cuisine.foobar.aa
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([any: "f"], [locale: "zz", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                cuisine.foo.zz,
                cuisine.foobar.zz
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([any: "f"], [locale: "aa_BB", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                cuisine.foo.aa,
                cuisine.foo.aa_bb,
                cuisine.foobar.aa,
                cuisine.foobar.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([any: "foo_name_a"], [locale: "aa", limit: 10])
            assert foo_id == page
            assert [
                cuisine.foo.aa
            ] == results

            assert { :ok, { results, page } } = Cuisine.find([any: "foo_name_a"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([any: "foo_name_a"], [locale: "aa_BB", limit: 10])
            assert foo_id == page
            assert Enum.sort([
                cuisine.foo.aa,
                cuisine.foo.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([any: "foo_continent_a"], [locale: "aa", limit: 10])
            assert foo_id == page
            assert [
                cuisine.foo.aa
            ] == results

            assert { :ok, { results, page } } = Cuisine.find([any: "foo_continent_a"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([any: "foo_continent_a"], [locale: "aa_BB", limit: 10])
            assert foo_id == page
            assert Enum.sort([
                cuisine.foo.aa,
                cuisine.foo.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Cuisine.find([any: "barfoo"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([any: "barfoo"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([any: "barfoo"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([any: "f", any: "b"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([any: "f", any: "b"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([any: "f", any: "b"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results
        end

        test "all queries", %{ id: %{ foobar: foobar_id }, region_id: %{ foobar: region_foobar_id }, data: cuisine } do
            assert { :ok, { results, page } } = Cuisine.find([name: "f", region: [id: region_foobar_id, continent: "fo"], any: "foob"], [locale: "aa", limit: 10])
            assert foobar_id == page
            assert [
                cuisine.foobar.aa
            ] == results

            assert { :ok, { results, page } } = Cuisine.find([name: "f", region: [id: region_foobar_id, continent: "fo"], any: "bar"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([name: "f", region: [id: region_foobar_id, continent: "ba"], any: "foob"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Cuisine.find([name: "b", region: [id: region_foobar_id, continent: "fo"], any: "foob"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results
        end

        test "region compatibility", %{ id: %{ bar: bar_id }, data: cuisine } do
            { :ok, { [region], _ } } = Region.find([continent: "b"], [locale: "aa"])
            assert { :ok, { cuisine.bar.aa, bar_id } } == Cuisine.find([region: [id: region.id]], [locale: "aa", limit: 10])

            { :ok, { [region], _ } } = Region.find([subregion: "b"], [locale: "aa"])
            assert { :ok, { cuisine.bar.aa, bar_id } } == Cuisine.find([region: [id: region.id]], [locale: "aa", limit: 10])

            { :ok, { [region], _ } } = Region.find([country: "b"], [locale: "aa"])
            assert { :ok, { cuisine.bar.aa, bar_id } } == Cuisine.find([region: [id: region.id]], [locale: "aa", limit: 10])

            { :ok, { [region], _ } } = Region.find([province: "b"], [locale: "aa"])
            assert { :ok, { cuisine.bar.aa, bar_id } } == Cuisine.find([region: [id: region.id]], [locale: "aa", limit: 10])
        end
    end
end
