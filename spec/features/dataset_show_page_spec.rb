require 'rails_helper'

feature 'Dataset page', elasticsearch: true do
  scenario 'Displays 404 page if a dataset is empty' do
    empty_dataset = {}

    index_and_visit(empty_dataset)

    expect(page.status_code).to eq(404)
    expect(page).to have_content('Not found')
  end

  feature 'Meta data' do
    scenario 'displays a location if there is one' do
      dataset = DatasetBuilder.new
                    .with_title(DATA_TITLE)
                    .build

      index_and_visit(dataset)

      expect(page).to have_content('Geographical area: London Southwark')
    end
  end

  feature 'Datalinks' do
    scenario 'displays if required fields present' do
      dataset = DatasetBuilder.new
                    .with_title(DATA_TITLE)
                    .with_datafiles(DATA_FILES_WITH_START_AND_ENDDATE)
                    .build

      index_and_visit(dataset)

      expect(page).to have_css('h2', text: 'Data links')
    end

    scenario 'do not display if datasets are missing' do
      dataset = DatasetBuilder.new
                    .with_title(DATA_TITLE)
                    .build

      index_and_visit(dataset)

      expect(page).to_not have_css('h2', text: 'Data links')
    end

    scenario 'display if some information is missing' do
      dataset = DatasetBuilder.new
                    .with_title(DATA_TITLE)
                    .with_datafiles(DATAFILES_WITHOUT_START_AND_ENDDATE)
                    .build

      index_and_visit(dataset)

      expect(page).to have_css('h2', text: 'Data links')
    end
  end

  feature 'Related datasets' do
    scenario 'displays related datasets if there is a match' do
      first_id = 1
      second_id = 2
      first_dataset_title = 'First dataset title'
      second_dataset_title = 'Second dataset data'

      first_dataset = DatasetBuilder.new
                          .with_title(first_dataset_title)
                          .with_datafiles(DATA_FILES_WITH_START_AND_ENDDATE)
                          .build

      second_dataset = DatasetBuilder.new
                          .with_title(second_dataset_title)
                          .with_datafiles(DATA_FILES_WITH_START_AND_ENDDATE)
                          .build

      index_data_with_id(first_dataset, first_id)
      index_data_with_id(second_dataset, second_id)

      refresh_index

      visit("/dataset/#{first_id}")

      expect(page).to have_content(second_dataset_title)
    end

    scenario 'does not display if related datasets is empty' do
      allow(Dataset).to receive(:search).and_return([])

      dataset = DatasetBuilder.new
                    .with_title(DATA_TITLE)
                    .with_datafiles(DATA_FILES_WITH_START_AND_ENDDATE)
                    .build

      index_and_visit(dataset)

      expect(page).to_not have_css('h3', text: 'Related datasets')
    end
  end

  feature 'Additional info' do
    scenario 'Is displayed if available' do
      notes = 'Some very interesting notes'
      dataset = DatasetBuilder.new
                    .with_title(DATA_TITLE)
                    .with_datafiles(DATA_FILES_WITH_START_AND_ENDDATE)
                    .with_notes(notes)
                    .build

      index_and_visit(dataset)

      expect(page).to have_content(notes)
    end
  end

  feature 'Publisher' do
    scenario 'Is displayed if available' do
      publisher = 'Ministry of Defence'
      dataset = DatasetBuilder.new
                    .with_title(DATA_TITLE)
                    .with_datafiles(DATA_FILES_WITH_START_AND_ENDDATE)
                    .build

      index_and_visit(dataset)

      expect(page).to have_content(publisher)
    end
  end

  def index_data_with_id(data, id)
    ELASTIC.index index: INDEX, type: 'dataset', id: id, body: data
  end
end
